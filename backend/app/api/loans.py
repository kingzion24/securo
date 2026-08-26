import uuid
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_async_session
from app.core.workspace_context import (
    WorkspaceContext,
    current_workspace,
    current_writable_workspace,
)
from app.schemas.loan import LoanCreate, LoanRead, LoanRepaymentCreate, LoanSummary, LoanUpdate
from app.services import loan_service

router = APIRouter(prefix="/api/loans", tags=["loans"])


@router.get("", response_model=list[LoanRead])
async def list_loans(
    direction: Optional[str] = Query(None),
    status_filter: Optional[str] = Query(None, alias="status"),
    ctx: WorkspaceContext = Depends(current_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    return await loan_service.get_loans(session, ctx.workspace.id, direction, status_filter)


@router.get("/summary", response_model=LoanSummary)
async def loan_summary(
    ctx: WorkspaceContext = Depends(current_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    return await loan_service.get_loan_summary(session, ctx.workspace.id, ctx.user_id)


@router.post("", response_model=LoanRead, status_code=status.HTTP_201_CREATED)
async def create_loan(
    data: LoanCreate,
    ctx: WorkspaceContext = Depends(current_writable_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    try:
        return await loan_service.create_loan(session, ctx.workspace.id, ctx.user_id, data)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.get("/{loan_id}", response_model=LoanRead)
async def get_loan(
    loan_id: uuid.UUID,
    ctx: WorkspaceContext = Depends(current_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    loan = await loan_service.get_loan(session, loan_id, ctx.workspace.id)
    if not loan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Loan not found")
    return loan


@router.patch("/{loan_id}", response_model=LoanRead)
async def update_loan(
    loan_id: uuid.UUID,
    data: LoanUpdate,
    ctx: WorkspaceContext = Depends(current_writable_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    try:
        loan = await loan_service.update_loan(session, loan_id, ctx.workspace.id, data)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    if not loan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Loan not found")
    return loan


@router.delete("/{loan_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_loan(
    loan_id: uuid.UUID,
    ctx: WorkspaceContext = Depends(current_writable_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    deleted = await loan_service.delete_loan(session, loan_id, ctx.workspace.id)
    if not deleted:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Loan not found")


@router.post("/{loan_id}/repayments", response_model=LoanRead, status_code=status.HTTP_201_CREATED)
async def add_repayment(
    loan_id: uuid.UUID,
    data: LoanRepaymentCreate,
    ctx: WorkspaceContext = Depends(current_writable_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    loan = await loan_service.add_repayment(session, loan_id, ctx.workspace.id, data)
    if not loan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Loan not found")
    return loan


@router.delete("/{loan_id}/repayments/{repayment_id}", response_model=LoanRead)
async def delete_repayment(
    loan_id: uuid.UUID,
    repayment_id: uuid.UUID,
    ctx: WorkspaceContext = Depends(current_writable_workspace),
    session: AsyncSession = Depends(get_async_session),
):
    loan = await loan_service.delete_repayment(session, loan_id, repayment_id, ctx.workspace.id)
    if not loan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Loan or repayment not found")
    return loan
