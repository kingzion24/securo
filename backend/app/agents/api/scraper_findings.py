from __future__ import annotations

import uuid
from typing import Any

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.agents.services import agent_service, findings_service
from app.core.database import get_async_session
from app.core.workspace_context import WorkspaceContext, current_workspace

router = APIRouter(prefix="/api/agents", tags=["agents"])


def _serialize(finding) -> dict[str, Any]:
    return {
        "id": str(finding.id),
        "agent_id": str(finding.agent_id),
        "source_key": finding.source_key,
        "title": finding.title,
        "url": finding.url,
        "discovered_at": finding.discovered_at.isoformat() if finding.discovered_at else None,
        "dismissed_at": finding.dismissed_at.isoformat() if finding.dismissed_at else None,
    }


@router.get("/{agent_id}/findings")
async def list_findings(
    agent_id: uuid.UUID,
    ctx: WorkspaceContext = Depends(current_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    agent = await agent_service.get_agent(session, agent_id, ctx.workspace.id)
    if agent is None:
        raise HTTPException(status_code=404, detail="agent not found")
    items = await findings_service.list_findings(session, agent_id)
    return {"items": [_serialize(f) for f in items], "total": len(items)}


@router.post("/{agent_id}/findings/{finding_id}/dismiss")
async def dismiss_finding(
    agent_id: uuid.UUID,
    finding_id: uuid.UUID,
    ctx: WorkspaceContext = Depends(current_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    agent = await agent_service.get_agent(session, agent_id, ctx.workspace.id)
    if agent is None:
        raise HTTPException(status_code=404, detail="agent not found")
    finding = await findings_service.dismiss_finding(session, agent_id, finding_id)
    if finding is None:
        raise HTTPException(status_code=404, detail="finding not found")
    return _serialize(finding)
