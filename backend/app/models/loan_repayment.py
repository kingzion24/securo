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
    from app.models.loan import Loan
    from app.models.transaction import Transaction


class LoanRepayment(Base):
    """A single (partial or full) payment against a Loan.

    `transaction_id` is optional so a repayment can either reconcile
    against a real transaction in the ledger, or be recorded manually
    (e.g. cash handed over with no bank record) — both are first-class.
    """
    __tablename__ = "loan_repayments"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    loan_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("loans.id", ondelete="CASCADE"))
    workspace_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("workspaces.id", ondelete="CASCADE"), index=True
    )
    amount: Mapped[Decimal] = mapped_column(Numeric(precision=15, scale=2))
    date: Mapped[date] = mapped_column(Date)
    note: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    # SET NULL on delete: the repayment record survives if the linked
    # transaction is later removed, same as GroupSettlement.transaction_id.
    transaction_id: Mapped[Optional[uuid.UUID]] = mapped_column(
        UUID(as_uuid=True), ForeignKey("transactions.id", ondelete="SET NULL"), nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    loan: Mapped["Loan"] = relationship(back_populates="repayments")
    transaction: Mapped[Optional["Transaction"]] = relationship()
