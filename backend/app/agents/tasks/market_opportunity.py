"""Daily task: the default agent (e.g. Scrooge) reviews content the
market-scraper found recently (backend/scraper, written into
scraper_findings — see app.agents.api.scraper_findings) and, if anything in
it looks worth the user's attention, writes 0-3 AgentNotification rows for
the notifications bell.

Deliberately conservative: as of writing, only UTT AMIS's news page yields
real per-item findings (DSE's site has an expired TLS cert, TanzaniaInvest
blocks scraper UAs with a WAF, and UTT AMIS's actual NAV/fund-performance
table sits behind an authenticated endpoint — see backend/scraper/sources/).
So the digest fed to the LLM is news headlines/snippets, not live prices,
and the prompt requires every suggestion to be traceable to something in
that digest and to say so explicitly — no invented tickers or numbers.
"""
from __future__ import annotations

import asyncio
import hashlib
import json
import logging
import os
from datetime import datetime, timedelta, timezone

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.agents.models.agent import Agent
from app.agents.models.scraper_finding import ScraperFinding
from app.agents.providers.base import ChatMessage
from app.agents.services import connection_service, notification_service, usage_service
from app.core.config import get_settings
from app.worker import celery_app

logger = logging.getLogger(__name__)

_SYSTEM_PROMPT = (
    "You are {name}, a personal-finance assistant. Below is a digest of "
    "Tanzania investment-market content scraped in the last few days "
    "(news headlines/snippets — NOT live prices or NAV data). Based ONLY "
    "on this digest, suggest at most 3 concrete things worth the user's "
    "attention (an opportunity, a notice, a deadline). If nothing in the "
    "digest is actually actionable, return an empty JSON array — never "
    "invent an opportunity, a ticker, or a number that isn't in the "
    "digest.\n\n"
    "Respond with ONLY a JSON array (no prose, no markdown fences). Each "
    "item:\n"
    '{{"title": "short headline, under 80 chars", '
    '"body": "2-4 sentences: what it is, why it might be worth a look, and '
    "an explicit caveat that this is based on scraped news rather than "
    'live pricing/NAV — verify before acting", '
    '"source_url": "the URL from the digest this is based on, or null"}}'
)


def _agents_enabled() -> bool:
    # Mirrors app.main's own check — this task must stay a no-op for users
    # who haven't opted into the agents feature at all, even though Celery
    # beat has no visibility into that FastAPI-side flag on its own.
    return os.getenv("AGENTS_ENABLED", "false").strip().lower() in ("1", "true", "yes", "on")


def _make_session_maker():
    settings = get_settings()
    engine = create_async_engine(settings.database_url)
    return engine, async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


async def _digest_for_agent(session: AsyncSession, agent_id, *, days: int = 30) -> str:
    # Wide window on purpose: findings are genuinely rare (the scraper only
    # records an item the first time it's ever seen — see
    # backend/scraper/findings.py — and the one working source, UTT AMIS
    # news, doesn't publish often), so a tight window is often just empty.
    # A news item doesn't go stale in days the way a price quote would;
    # de-duplication of the notifications themselves (dedup_key, below)
    # is what stops the same digest from generating the same suggestion
    # on every run, not this window.
    since = datetime.now(timezone.utc) - timedelta(days=days)
    rows = (await session.execute(
        select(ScraperFinding)
        .where(ScraperFinding.agent_id == agent_id, ScraperFinding.discovered_at >= since)
        .order_by(ScraperFinding.discovered_at.desc())
        .limit(30)
    )).scalars().all()
    return "\n".join(f"- [{r.source_key}] {r.title} — {r.url}" for r in rows)


async def _scan_agent(session: AsyncSession, agent: Agent) -> int:
    digest = await _digest_for_agent(session, agent.id)
    if not digest:
        return 0

    conn = None
    if agent.connection_id:
        conn = await connection_service.get_connection(session, agent.connection_id, agent.user_id)
    if conn is None:
        conn = await connection_service.get_default_connection(session, agent.user_id)
    if conn is None:
        logger.info("market_opportunity: agent %s has no LLM connection, skipping", agent.id)
        return 0

    model = agent.model or conn.default_model
    if not model:
        logger.info("market_opportunity: agent %s / connection %s has no model configured, skipping", agent.id, conn.id)
        return 0

    provider = connection_service.build_provider_for_connection(conn)
    messages = [
        ChatMessage(role="system", content=_SYSTEM_PROMPT.format(name=agent.name or "Scrooge")),
        ChatMessage(role="user", content=f"Recent Tanzania market digest:\n\n{digest}"),
    ]
    try:
        response = await provider.chat(messages, model=model, temperature=0.3, max_tokens=1500)
    except Exception:
        logger.exception("market_opportunity: LLM call failed for agent %s", agent.id)
        return 0

    try:
        await usage_service.record_usage(
            session,
            user_id=agent.user_id,
            agent_id=agent.id,
            conversation_id=None,
            message_id=None,
            provider=provider.name,
            model=model,
            kind="chat",
            input_tokens=response.usage.input_tokens,
            output_tokens=response.usage.output_tokens,
        )
    except Exception:
        logger.exception("market_opportunity: usage logging failed for agent %s", agent.id)

    content = (response.content or "").strip()
    # Models occasionally wrap JSON in a fenced block despite instructions;
    # strip that rather than failing the whole scan over formatting.
    if content.startswith("```"):
        content = content.strip("`")
        if content.lower().startswith("json"):
            content = content[4:]
        content = content.strip()

    try:
        items = json.loads(content)
    except json.JSONDecodeError:
        logger.warning("market_opportunity: agent %s returned non-JSON, skipping: %r", agent.id, content[:300])
        return 0
    if not isinstance(items, list):
        return 0

    created = 0
    for item in items[:3]:
        if not isinstance(item, dict):
            continue
        title = (item.get("title") or "").strip()
        body = (item.get("body") or "").strip()
        if not title or not body:
            continue
        source_url = (item.get("source_url") or None) or None
        # Dedup on the source item, not the generated title: the LLM's
        # wording drifts slightly run to run even at low temperature (e.g.
        # "UTT AMIS Portal & Mobile App Upgrades Live" vs "...Upgrades"),
        # but it copies source_url verbatim from the digest, so that's the
        # stable identity. Only fall back to title when there's no URL.
        dedup_key = hashlib.sha256((source_url or title).strip().lower().encode("utf-8")).hexdigest()[:32]
        row = await notification_service.create_if_new(
            session,
            agent_id=agent.id,
            type="investment_opportunity",
            title=title,
            body=body,
            source_url=source_url,
            dedup_key=dedup_key,
        )
        if row is not None:
            created += 1
    return created


async def _scan_all() -> dict:
    engine, session_maker = _make_session_maker()
    total = 0
    try:
        async with session_maker() as session:
            agents = list((await session.execute(
                select(Agent).where(Agent.is_default.is_(True), Agent.is_archived.is_(False))
            )).scalars().all())

        for agent in agents:
            async with session_maker() as session:
                try:
                    total += await _scan_agent(session, agent)
                except Exception:
                    logger.exception("market_opportunity: scan failed for agent %s", agent.id)
    finally:
        await engine.dispose()
    return {"created": total, "agents_scanned": len(agents)}


@celery_app.task(name="app.agents.tasks.market_opportunity.scan_market_opportunities")
def scan_market_opportunities() -> dict:
    """Celery task: run the market-opportunity scan for every default agent."""
    if not _agents_enabled():
        return {"created": 0, "skipped": "AGENTS_ENABLED is off"}
    result = asyncio.run(_scan_all())
    logger.info("market_opportunity scan complete: %d notification(s) created", result.get("created", 0))
    return result
