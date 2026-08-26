"""create loans and loan_repayments tables

Revision ID: 075
Revises: 074
Create Date: 2026-08-26
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

revision: str = "075"
down_revision: Union[str, None] = "074"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "loans",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column("user_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("users.id"), nullable=False),
        sa.Column("workspace_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False),
        sa.Column("person_name", sa.String(255), nullable=False),
        sa.Column("payee_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("payees.id", ondelete="SET NULL"), nullable=True),
        sa.Column("direction", sa.String(20), nullable=False),
        sa.Column("principal_amount", sa.Numeric(precision=15, scale=2), nullable=False),
        sa.Column("currency", sa.String(3), nullable=False, server_default="USD"),
        sa.Column("date", sa.Date(), nullable=False),
        sa.Column("note", sa.String(1000), nullable=True),
        sa.Column("status", sa.String(20), nullable=False, server_default="open"),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index("ix_loans_workspace_id", "loans", ["workspace_id"])
    op.create_index("ix_loans_workspace_status", "loans", ["workspace_id", "status"])

    op.create_table(
        "loan_repayments",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column("loan_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("loans.id", ondelete="CASCADE"), nullable=False),
        sa.Column("workspace_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("workspaces.id", ondelete="CASCADE"), nullable=False),
        sa.Column("amount", sa.Numeric(precision=15, scale=2), nullable=False),
        sa.Column("date", sa.Date(), nullable=False),
        sa.Column("note", sa.String(1000), nullable=True),
        sa.Column("transaction_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("transactions.id", ondelete="SET NULL"), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now()),
    )
    op.create_index("ix_loan_repayments_workspace_id", "loan_repayments", ["workspace_id"])
    op.create_index("ix_loan_repayments_loan_id", "loan_repayments", ["loan_id"])


def downgrade() -> None:
    op.drop_index("ix_loan_repayments_loan_id", table_name="loan_repayments")
    op.drop_index("ix_loan_repayments_workspace_id", table_name="loan_repayments")
    op.drop_table("loan_repayments")
    op.drop_index("ix_loans_workspace_status", table_name="loans")
    op.drop_index("ix_loans_workspace_id", table_name="loans")
    op.drop_table("loans")
