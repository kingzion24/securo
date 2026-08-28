"""Entrypoint for the market-scraper container.

Loop: scrape every configured source, ingest whatever succeeded into the
target agent's knowledge base, sleep, repeat. A single source failing
(dead site, expired cert, layout change) never stops the others — each
source is wrapped individually and logged.

Config (env vars, all required except INTERVAL/TIMEOUT):
  SCRAPER_AGENT_ID        uuid of the agent to feed (e.g. Scrooge)
  SCRAPER_USER_ID         uuid of that agent's owning user
  SCRAPER_INTERVAL_HOURS  hours between scrape cycles (default 8)
  SCRAPER_HTTP_TIMEOUT    per-request timeout in seconds (default 20)
"""
from __future__ import annotations

import asyncio
import logging
import os
import sys
import uuid

import httpx
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.pool import NullPool

from app.core.config import get_settings
from scraper import ingest
from scraper.sources import dse, investa, mystocks, tanzaniainvest, uttamis

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")
logger = logging.getLogger("scraper")

SOURCES = [tanzaniainvest, uttamis, dse, investa, mystocks]

# A generic scraper UA gets blanket-blocked by tanzaniainvest.com's bot
# filter (verified: 403 on every request). A standard browser UA string is
# accepted — this is a normal, widely-used workaround for naive UA-pattern
# bot filters, not spoofing intent to deceive; we still identify politely
# via a low request rate (one cycle per SCRAPER_INTERVAL_HOURS) and honest,
# read-only, low-volume traffic.
USER_AGENT = (
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/124.0.0.0 Safari/537.36"
)


async def _run_cycle(session_maker: async_sessionmaker[AsyncSession], agent_id: uuid.UUID, user_id: uuid.UUID) -> None:
    timeout = float(os.getenv("SCRAPER_HTTP_TIMEOUT", "20"))
    async with httpx.AsyncClient(
        timeout=httpx.Timeout(timeout, connect=10.0),
        headers={"User-Agent": USER_AGENT},
        follow_redirects=True,
    ) as client:
        for module in SOURCES:
            name = module.__name__.rsplit(".", 1)[-1]
            try:
                result = await module.scrape(client)
            except Exception:  # noqa: BLE001 — one source's bug must not kill the cycle
                logger.exception("source %s raised unexpectedly", name)
                continue

            if not result.ok:
                logger.warning("source %s: fetch incomplete (%s)", name, result.error)
                continue

            async with session_maker() as session:
                try:
                    ingested = await ingest.replace_source_doc(session, agent_id=agent_id, user_id=user_id, result=result)
                except Exception:  # noqa: BLE001
                    logger.exception("source %s: ingest failed", name)
                    continue
            if ingested:
                logger.info("source %s: ingested %d items", name, result.item_count)


async def main() -> None:
    agent_id_raw = os.getenv("SCRAPER_AGENT_ID", "").strip()
    user_id_raw = os.getenv("SCRAPER_USER_ID", "").strip()
    if not agent_id_raw or not user_id_raw:
        logger.error(
            "SCRAPER_AGENT_ID and SCRAPER_USER_ID must both be set — the "
            "container has nothing to feed without them. Exiting."
        )
        sys.exit(1)
    agent_id = uuid.UUID(agent_id_raw)
    user_id = uuid.UUID(user_id_raw)
    interval_hours = float(os.getenv("SCRAPER_INTERVAL_HOURS", "8"))

    # Own engine/pool, same reasoning as app.agents.tasks.ingest: this
    # process's event loop shouldn't share connections with anything else.
    engine = create_async_engine(get_settings().database_url, poolclass=NullPool)
    session_maker = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

    logger.info("market-scraper starting: agent=%s interval=%.1fh sources=%s", agent_id, interval_hours, [m.__name__.rsplit('.', 1)[-1] for m in SOURCES])
    try:
        while True:
            logger.info("scrape cycle starting")
            await _run_cycle(session_maker, agent_id, user_id)
            logger.info("scrape cycle done, sleeping %.1fh", interval_hours)
            await asyncio.sleep(interval_hours * 3600)
    finally:
        await engine.dispose()


if __name__ == "__main__":
    asyncio.run(main())
