"""Detects "new since last cycle" items and records them for the What's
New widget (see app.agents.api.scraper_findings).

Only sources that expose a genuine, stable headline/URL list (currently:
UTT AMIS news & announcements) participate — a source without a stable
per-item identity (full-text article scrapes, NAV tables, static nav
links) has nothing meaningful to diff.
"""
from __future__ import annotations

import logging
import uuid

from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from app.agents.models.scraper_finding import ScraperFinding
from scraper.sources import SourceResult

logger = logging.getLogger(__name__)


async def record_findings(session: AsyncSession, *, agent_id: uuid.UUID, result: SourceResult) -> int:
    """Insert any items not already known for this agent+source. Returns
    the count of genuinely new items. `ON CONFLICT DO NOTHING` on the
    (agent_id, url) unique constraint makes this safe to call every cycle
    even though most items will already exist."""
    if not result.items:
        return 0

    stmt = pg_insert(ScraperFinding).values([
        {
            "id": uuid.uuid4(),
            "agent_id": agent_id,
            "source_key": result.source_key,
            "title": title,
            "url": url,
        }
        for title, url in result.items
    ]).on_conflict_do_nothing(
        index_elements=["agent_id", "url"],
    ).returning(ScraperFinding.id)

    inserted = (await session.execute(stmt)).all()
    await session.commit()
    if inserted:
        logger.info("scraper: %d new item(s) found for %s", len(inserted), result.source_key)
    return len(inserted)
