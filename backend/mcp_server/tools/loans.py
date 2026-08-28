from __future__ import annotations

from typing import Any

from sqlalchemy.ext.asyncio import AsyncSession

from app.services import loan_service
from mcp_server.auth import CallContext
from mcp_server.registry import tool
from mcp_server.tools._helpers import num, resolve_workspace_id


@tool(
    name="list_loans",
    description=(
        "List person-to-person loans/IOUs (money the user lent to someone, "
        "or borrowed from someone) with repayment progress. Personal "
        "workspaces only."
    ),
    parameters={
        "type": "object",
        "properties": {
            "direction": {
                "type": "string",
                "enum": ["they_owe_me", "i_owe_them"],
                "description": "Optional filter by who owes whom.",
            },
            "status": {
                "type": "string",
                "enum": ["open", "settled"],
                "description": "Optional filter by loan status.",
            },
        },
        "additionalProperties": False,
    },
    tags=["read", "loans"],
)
async def list_loans(
    *,
    session: AsyncSession,
    ctx: CallContext,
    direction: str | None = None,
    status: str | None = None,
) -> dict[str, Any]:
    ws_id = await resolve_workspace_id(session, ctx)
    rows = await loan_service.get_loans(session, ws_id, direction=direction, status=status)
    items = [
        {
            "id": str(loan.id),
            "person_name": loan.person_name,
            "direction": loan.direction,
            "principal_amount": num(loan.principal_amount),
            "currency": loan.currency,
            "date": loan.date.isoformat(),
            "status": loan.status,
            "note": loan.note,
            "repaid_amount": num(loan.repaid_amount),
            "remaining_amount": num(loan.remaining_amount),
            "percentage": loan.percentage,
        }
        for loan in rows
    ]
    return {"items": items, "total": len(items)}


@tool(
    name="get_loan_summary",
    description=(
        "Totals across all open loans, converted to the user's primary "
        "currency: how much is owed to the user, and how much the user owes "
        "others."
    ),
    parameters={"type": "object", "properties": {}, "additionalProperties": False},
    tags=["read", "loans"],
)
async def get_loan_summary(
    *,
    session: AsyncSession,
    ctx: CallContext,
) -> dict[str, Any]:
    ws_id = await resolve_workspace_id(session, ctx)
    summary = await loan_service.get_loan_summary(session, ws_id, ctx.user_id)
    return {
        "total_owed_to_me": num(summary.total_owed_to_me),
        "total_i_owe": num(summary.total_i_owe),
        "currency": summary.currency,
        "open_count": summary.open_count,
    }
