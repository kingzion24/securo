"""Read/dismiss side of scraper_findings — the write side lives in the
market-scraper container (backend/scraper/findings.py), which has no
reason to import the rest of the backend app beyond the ORM model."""
from __future__ import annotations

import uuid
from typing import Optional

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.sql import func

from app.agents.models.scraper_finding import ScraperFinding


async def list_findings(
    session: AsyncSession, agent_id: uuid.UUID, *, include_dismissed: bool = False, limit: int = 50
) -> list[ScraperFinding]:
    query = select(ScraperFinding).where(ScraperFinding.agent_id == agent_id)
    if not include_dismissed:
        query = query.where(ScraperFinding.dismissed_at.is_(None))
    query = query.order_by(ScraperFinding.discovered_at.desc()).limit(limit)
    return list((await session.execute(query)).scalars().all())


async def dismiss_finding(session: AsyncSession, agent_id: uuid.UUID, finding_id: uuid.UUID) -> Optional[ScraperFinding]:
    finding = (await session.execute(
        select(ScraperFinding).where(ScraperFinding.id == finding_id, ScraperFinding.agent_id == agent_id)
    )).scalar_one_or_none()
    if finding is None:
        return None
    await session.execute(
        update(ScraperFinding).where(ScraperFinding.id == finding_id).values(dismissed_at=func.now())
    )
    await session.commit()
    await session.refresh(finding)
    return finding
