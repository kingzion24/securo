"""Read/dismiss/create side of agent_notifications — proactive suggestions
an agent generated on its own (see app.agents.tasks.market_opportunity),
surfaced via the notifications bell in the app shell. List/dismiss are
workspace-scoped (a user sees notifications from every agent in their
workspace, not just one); creation is per-agent and dedupes on
(agent_id, dedup_key) the same way scraper_findings dedupes on
(agent_id, url).
"""
from __future__ import annotations

import uuid
from typing import Optional

from sqlalchemy import select, update
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.sql import func

from app.agents.models.agent import Agent
from app.agents.models.notification import AgentNotification


async def list_notifications(
    session: AsyncSession, workspace_id: uuid.UUID, *, include_dismissed: bool = False, limit: int = 50
) -> list[AgentNotification]:
    query = (
        select(AgentNotification)
        .join(Agent, Agent.id == AgentNotification.agent_id)
        .where(Agent.workspace_id == workspace_id)
    )
    if not include_dismissed:
        query = query.where(AgentNotification.dismissed_at.is_(None))
    query = query.order_by(AgentNotification.created_at.desc()).limit(limit)
    return list((await session.execute(query)).scalars().all())


async def dismiss_notification(
    session: AsyncSession, workspace_id: uuid.UUID, notification_id: uuid.UUID
) -> Optional[AgentNotification]:
    notification = (await session.execute(
        select(AgentNotification)
        .join(Agent, Agent.id == AgentNotification.agent_id)
        .where(AgentNotification.id == notification_id, Agent.workspace_id == workspace_id)
    )).scalar_one_or_none()
    if notification is None:
        return None
    await session.execute(
        update(AgentNotification).where(AgentNotification.id == notification_id).values(dismissed_at=func.now())
    )
    await session.commit()
    await session.refresh(notification)
    return notification


async def create_if_new(
    session: AsyncSession,
    *,
    agent_id: uuid.UUID,
    type: str,
    title: str,
    body: str,
    source_url: Optional[str],
    dedup_key: str,
) -> Optional[AgentNotification]:
    """Insert unless (agent_id, dedup_key) already exists. Returns the new
    row, or None if it was a duplicate (mirrors findings_service's
    ON CONFLICT DO NOTHING pattern — safe to call on every scan run)."""
    stmt = pg_insert(AgentNotification).values(
        id=uuid.uuid4(),
        agent_id=agent_id,
        type=type,
        title=title,
        body=body,
        source_url=source_url,
        dedup_key=dedup_key,
    ).on_conflict_do_nothing(
        index_elements=["agent_id", "dedup_key"],
    ).returning(AgentNotification)

    row = (await session.execute(stmt)).scalar_one_or_none()
    await session.commit()
    return row
