import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import DateTime, ForeignKey, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func

from app.core.database import Base


class ScraperFinding(Base):
    """One "new since last cycle" item discovered by the market-scraper
    (see backend/scraper). Keyed on (agent_id, url) so the same headline
    seen across multiple scrape cycles is recorded once, with
    `discovered_at` fixed to the first time it was ever seen — that's what
    makes the "what's new" widget actually mean something instead of just
    re-listing the same items every 8 hours.
    """
    __tablename__ = "scraper_findings"
    __table_args__ = (UniqueConstraint("agent_id", "url", name="uq_scraper_findings_agent_url"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    agent_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("agents.id", ondelete="CASCADE"), index=True)

    source_key: Mapped[str] = mapped_column(String(40))
    title: Mapped[str] = mapped_column(Text)
    url: Mapped[str] = mapped_column(Text)

    discovered_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    dismissed_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
