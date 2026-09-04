import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import DateTime, ForeignKey, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func

from app.core.database import Base


class AgentNotification(Base):
    """A proactive suggestion an agent generated on its own (not in
    response to a chat message) — e.g. the daily market-opportunity scan
    (see app.agents.tasks.market_opportunity) reviewing recently-scraped
    Tanzania market content and writing up anything worth the user's
    attention. Surfaced via the notifications bell in the app shell.

    `dedup_key` is scoped per agent (not globally) so the same suggestion
    text re-generated on a later run doesn't spam the list — see the
    unique constraint below and its ON CONFLICT DO NOTHING use in
    notification_service.create_if_new.
    """
    __tablename__ = "agent_notifications"
    __table_args__ = (
        UniqueConstraint("agent_id", "dedup_key", name="uq_agent_notifications_agent_dedup"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    agent_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("agents.id", ondelete="CASCADE"), index=True)

    type: Mapped[str] = mapped_column(String(40))
    title: Mapped[str] = mapped_column(Text)
    body: Mapped[str] = mapped_column(Text)
    source_url: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    dedup_key: Mapped[str] = mapped_column(String(64))

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    dismissed_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
