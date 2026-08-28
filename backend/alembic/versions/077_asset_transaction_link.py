"""link asset transactions to a bank transaction

Revision ID: 077
Revises: 076
Create Date: 2026-08-26
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

revision: str = "077"
down_revision: Union[str, None] = "076b"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        "asset_transactions",
        sa.Column(
            "transaction_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("transactions.id", ondelete="SET NULL"),
            nullable=True,
        ),
    )
    op.create_index(
        "ix_asset_transactions_transaction_id", "asset_transactions", ["transaction_id"]
    )


def downgrade() -> None:
    op.drop_index("ix_asset_transactions_transaction_id", table_name="asset_transactions")
    op.drop_column("asset_transactions", "transaction_id")
