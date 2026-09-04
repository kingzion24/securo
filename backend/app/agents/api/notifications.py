from __future__ import annotations

import uuid
from typing import Any

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.agents.services import notification_service
from app.core.database import get_async_session
from app.core.workspace_context import WorkspaceContext, current_workspace

# Literal prefix — must be mounted before the generic /{agent_id} agents
# router (see app/main.py) so this path isn't captured as an agent id.
router = APIRouter(prefix="/api/agents/notifications", tags=["agents"])


def _serialize(notification) -> dict[str, Any]:
    return {
        "id": str(notification.id),
        "agent_id": str(notification.agent_id),
        "type": notification.type,
        "title": notification.title,
        "body": notification.body,
        "source_url": notification.source_url,
        "created_at": notification.created_at.isoformat() if notification.created_at else None,
        "dismissed_at": notification.dismissed_at.isoformat() if notification.dismissed_at else None,
    }


@router.get("")
async def list_notifications(
    ctx: WorkspaceContext = Depends(current_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    items = await notification_service.list_notifications(session, ctx.workspace.id)
    return {"items": [_serialize(n) for n in items], "total": len(items)}


@router.post("/{notification_id}/dismiss")
async def dismiss_notification(
    notification_id: uuid.UUID,
    ctx: WorkspaceContext = Depends(current_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    notification = await notification_service.dismiss_notification(session, ctx.workspace.id, notification_id)
    if notification is None:
        raise HTTPException(status_code=404, detail="notification not found")
    return _serialize(notification)
