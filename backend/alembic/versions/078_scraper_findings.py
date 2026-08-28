"""track new-since-last-cycle items found by the market-scraper

Revision ID: 078
Revises: 077
Create Date: 2026-08-28
"""

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

revision: str = "078"
down_revision: Union[str, None] = "077"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "scraper_findings",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True),
        sa.Column("agent_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("agents.id", ondelete="CASCADE"), nullable=False),
        sa.Column("source_key", sa.String(length=40), nullable=False),
        sa.Column("title", sa.Text(), nullable=False),
        sa.Column("url", sa.Text(), nullable=False),
        sa.Column("discovered_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.Column("dismissed_at", sa.DateTime(timezone=True), nullable=True),
        sa.UniqueConstraint("agent_id", "url", name="uq_scraper_findings_agent_url"),
    )
    op.create_index("ix_scraper_findings_agent_id", "scraper_findings", ["agent_id"])


def downgrade() -> None:
    op.drop_index("ix_scraper_findings_agent_id", table_name="scraper_findings")
    op.drop_table("scraper_findings")
