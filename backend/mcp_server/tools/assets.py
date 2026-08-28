from __future__ import annotations

from typing import Any

from sqlalchemy.ext.asyncio import AsyncSession

from app.services.asset_transaction_service import list_workspace_transactions
from mcp_server.auth import CallContext
from mcp_server.registry import tool
from mcp_server.tools._helpers import resolve_workspace_id


@tool(
    name="list_asset_transactions",
    description=(
        "List the buy/sell/deposit/withdrawal ledger entries across all "
        "tracked assets (or filter to one holding by ticker). Use this to "
        "answer questions about contribution/withdrawal history, e.g. UTT "
        "bond fund purchases or a private investment's deposits — "
        "list_assets only has the current snapshot, this has the history."
    ),
    parameters={
        "type": "object",
        "properties": {
            "ticker": {"type": "string", "description": "Optional ticker filter (e.g. a market-priced holding's symbol)."},
            "kind": {
                "type": "string",
                "enum": ["buy", "sell", "deposit", "withdrawal"],
                "description": "Optional filter by transaction kind.",
            },
            "limit": {"type": "integer", "default": 100, "minimum": 1, "maximum": 500},
        },
        "additionalProperties": False,
    },
    tags=["read", "assets"],
)
async def list_asset_transactions(
    *,
    session: AsyncSession,
    ctx: CallContext,
    ticker: str | None = None,
    kind: str | None = None,
    limit: int = 100,
) -> dict[str, Any]:
    ws_id = await resolve_workspace_id(session, ctx)
    rows = await list_workspace_transactions(session, ws_id, ticker=ticker, kind=kind, limit=limit)
    items = [
        {
            "id": str(t.id),
            "asset_id": str(t.asset_id),
            "asset_name": t.asset_name,
            "ticker": t.ticker,
            "kind": t.kind,
            "quantity": t.quantity,
            "price": t.price,
            "fee": t.fee,
            "currency": t.currency,
            "date": t.date.isoformat(),
            "notes": t.notes,
            "linked_transaction_description": t.transaction_description,
        }
        for t in rows
    ]
    return {"items": items, "total": len(items)}
