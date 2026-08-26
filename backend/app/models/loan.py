import uuid
from datetime import date, datetime
from decimal import Decimal
from typing import TYPE_CHECKING, Optional

from sqlalchemy import Date, DateTime, ForeignKey, Numeric, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.core.database import Base

if TYPE_CHECKING:
    from app.models.loan_repayment import LoanRepayment
    from app.models.payee import Payee
    from app.models.user import User


class Loan(Base):
    """A personal IOU: money lent to, or borrowed from, another person.

    Deliberately not tied to an account — the money involved lives in a
    normal bank account already tracked elsewhere. This just tracks who
    owes whom, independent of where the cash physically sits.
    """
    __tablename__ = "loans"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"))
    workspace_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("workspaces.id", ondelete="CASCADE"), index=True
    )
    person_name: Mapped[str] = mapped_column(String(255))
    # Optional link to an existing Payee, purely for reuse of a name
    # already in the workspace. Never required — most loans are to people
    # who never show up as a transaction payee (family, friends).
    payee_id: Mapped[Optional[uuid.UUID]] = mapped_column(
        UUID(as_uuid=True), ForeignKey("payees.id", ondelete="SET NULL"), nullable=True
    )
    direction: Mapped[str] = mapped_column(String(20))  # they_owe_me, i_owe_them
    principal_amount: Mapped[Decimal] = mapped_column(Numeric(precision=15, scale=2))
    currency: Mapped[str] = mapped_column(String(3), default="USD")
    date: Mapped[date] = mapped_column(Date)
    note: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="open")  # open, settled, archived
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    user: Mapped["User"] = relationship()
    payee: Mapped[Optional["Payee"]] = relationship()
    repayments: Mapped[list["LoanRepayment"]] = relationship(
        back_populates="loan", cascade="all, delete-orphan", order_by="LoanRepayment.date.desc()"
    )
