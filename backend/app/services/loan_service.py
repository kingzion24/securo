import uuid
from decimal import Decimal
from typing import Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.config import get_settings
from app.models.loan import Loan
from app.models.loan_repayment import LoanRepayment
from app.models.payee import Payee
from app.models.user import User
from app.schemas.loan import (
    LoanCreate,
    LoanRead,
    LoanRepaymentCreate,
    LoanRepaymentRead,
    LoanSummary,
    LoanUpdate,
)
from app.services.fx_rate_service import convert


async def _get_primary_currency(session: AsyncSession, user_id: uuid.UUID) -> str:
    user = await session.get(User, user_id)
    return user.primary_currency if user else get_settings().default_currency


async def _convert_amount(
    session: AsyncSession, amount: Decimal, from_currency: str, to_currency: str
) -> Decimal:
    if from_currency == to_currency:
        return amount
    converted, _ = await convert(session, amount, from_currency, to_currency)
    return converted


def _compute_percentage(repaid: Decimal, principal: Decimal) -> float:
    if principal <= 0:
        return 100.0 if repaid > 0 else 0.0
    return round(float(min(repaid, principal) / principal) * 100, 1)


async def _enrich_loan(session: AsyncSession, loan: Loan) -> LoanRead:
    repaid = sum((r.amount for r in loan.repayments), Decimal("0"))
    remaining = loan.principal_amount - repaid
    payee_name = None
    if loan.payee_id:
        payee = await session.get(Payee, loan.payee_id)
        payee_name = payee.name if payee else None

    return LoanRead(
        id=loan.id,
        user_id=loan.user_id,
        person_name=loan.person_name,
        payee_id=loan.payee_id,
        payee_name=payee_name,
        direction=loan.direction,
        principal_amount=loan.principal_amount,
        currency=loan.currency,
        date=loan.date,
        note=loan.note,
        status=loan.status,
        created_at=loan.created_at,
        updated_at=loan.updated_at,
        repaid_amount=repaid,
        remaining_amount=remaining,
        percentage=_compute_percentage(repaid, loan.principal_amount),
        repayments=[LoanRepaymentRead.model_validate(r) for r in loan.repayments],
    )


async def _get_loan(session: AsyncSession, loan_id: uuid.UUID, workspace_id: uuid.UUID) -> Optional[Loan]:
    # populate_existing=True: this session has expire_on_commit=False, so
    # after committing a new repayment, the identity-mapped Loan object
    # this call returns (same Python object, same session) already has a
    # (now stale) `.repayments` loaded from an earlier call — selectinload
    # alone won't overwrite an already-loaded relationship. This forces it
    # to actually apply the fresh query results instead of skipping them.
    result = await session.execute(
        select(Loan)
        .where(Loan.id == loan_id, Loan.workspace_id == workspace_id)
        .options(selectinload(Loan.repayments))
        .execution_options(populate_existing=True)
    )
    return result.scalar_one_or_none()


async def get_loans(
    session: AsyncSession,
    workspace_id: uuid.UUID,
    direction: Optional[str] = None,
    status: Optional[str] = None,
) -> list[LoanRead]:
    query = (
        select(Loan)
        .where(Loan.workspace_id == workspace_id)
        .order_by(Loan.date.desc(), Loan.created_at.desc())
        .options(selectinload(Loan.repayments))
        .execution_options(populate_existing=True)
    )
    if direction:
        query = query.where(Loan.direction == direction)
    if status:
        query = query.where(Loan.status == status)
    result = await session.execute(query)
    loans = list(result.scalars().unique().all())
    return [await _enrich_loan(session, loan) for loan in loans]


async def get_loan(session: AsyncSession, loan_id: uuid.UUID, workspace_id: uuid.UUID) -> Optional[LoanRead]:
    loan = await _get_loan(session, loan_id, workspace_id)
    if not loan:
        return None
    return await _enrich_loan(session, loan)


async def create_loan(
    session: AsyncSession, workspace_id: uuid.UUID, user_id: uuid.UUID, data: LoanCreate,
) -> LoanRead:
    if data.payee_id:
        payee = await session.get(Payee, data.payee_id)
        if not payee or payee.workspace_id != workspace_id:
            raise ValueError("Linked payee not found")

    loan = Loan(
        user_id=user_id,
        workspace_id=workspace_id,
        person_name=data.person_name,
        payee_id=data.payee_id,
        direction=data.direction,
        principal_amount=data.principal_amount,
        currency=data.currency,
        date=data.date,
        note=data.note,
    )
    session.add(loan)
    await session.commit()
    # A plain refresh() only reloads column attributes, not relationships,
    # and commit() expires everything — so a fresh eager-loaded re-fetch
    # (rather than a partial refresh) is what actually leaves both the
    # scalar columns and .repayments safe to read without another await.
    loan = await _get_loan(session, loan.id, workspace_id)
    return await _enrich_loan(session, loan)


async def update_loan(
    session: AsyncSession, loan_id: uuid.UUID, workspace_id: uuid.UUID, data: LoanUpdate,
) -> Optional[LoanRead]:
    loan = await _get_loan(session, loan_id, workspace_id)
    if not loan:
        return None
    if data.payee_id is not None:
        payee = await session.get(Payee, data.payee_id)
        if not payee or payee.workspace_id != workspace_id:
            raise ValueError("Linked payee not found")
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(loan, field, value)
    await session.commit()
    loan = await _get_loan(session, loan_id, workspace_id)
    return await _enrich_loan(session, loan)


async def delete_loan(session: AsyncSession, loan_id: uuid.UUID, workspace_id: uuid.UUID) -> bool:
    loan = await _get_loan(session, loan_id, workspace_id)
    if not loan:
        return False
    await session.delete(loan)
    await session.commit()
    return True


async def add_repayment(
    session: AsyncSession, loan_id: uuid.UUID, workspace_id: uuid.UUID, data: LoanRepaymentCreate,
) -> Optional[LoanRead]:
    loan = await _get_loan(session, loan_id, workspace_id)
    if not loan:
        return None
    repayment = LoanRepayment(
        loan_id=loan.id,
        workspace_id=workspace_id,
        amount=data.amount,
        date=data.date,
        note=data.note,
        transaction_id=data.transaction_id,
    )
    session.add(repayment)
    await session.commit()
    loan = await _get_loan(session, loan_id, workspace_id)
    return await _enrich_loan(session, loan)


async def delete_repayment(
    session: AsyncSession, loan_id: uuid.UUID, repayment_id: uuid.UUID, workspace_id: uuid.UUID,
) -> Optional[LoanRead]:
    loan = await _get_loan(session, loan_id, workspace_id)
    if not loan:
        return None
    result = await session.execute(
        select(LoanRepayment).where(
            LoanRepayment.id == repayment_id,
            LoanRepayment.loan_id == loan_id,
            LoanRepayment.workspace_id == workspace_id,
        )
    )
    repayment = result.scalar_one_or_none()
    if not repayment:
        return None
    await session.delete(repayment)
    await session.commit()
    loan = await _get_loan(session, loan_id, workspace_id)
    return await _enrich_loan(session, loan)


async def get_loan_summary(
    session: AsyncSession, workspace_id: uuid.UUID, user_id: uuid.UUID,
) -> LoanSummary:
    result = await session.execute(
        select(Loan)
        .where(Loan.workspace_id == workspace_id, Loan.status == "open")
        .options(selectinload(Loan.repayments))
        .execution_options(populate_existing=True)
    )
    loans = list(result.scalars().unique().all())
    primary_currency = await _get_primary_currency(session, user_id)

    total_owed_to_me = Decimal("0")
    total_i_owe = Decimal("0")
    for loan in loans:
        repaid = sum((r.amount for r in loan.repayments), Decimal("0"))
        remaining = loan.principal_amount - repaid
        if remaining <= 0:
            continue
        converted = await _convert_amount(session, remaining, loan.currency, primary_currency)
        if loan.direction == "they_owe_me":
            total_owed_to_me += converted
        else:
            total_i_owe += converted

    return LoanSummary(
        total_owed_to_me=total_owed_to_me,
        total_i_owe=total_i_owe,
        currency=primary_currency,
        open_count=len(loans),
    )
