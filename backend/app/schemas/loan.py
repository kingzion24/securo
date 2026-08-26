import uuid
from datetime import date as _Date, datetime
from decimal import Decimal
from typing import Optional

from pydantic import BaseModel, ConfigDict, field_validator

_DIRECTIONS = ("they_owe_me", "i_owe_them")
_STATUSES = ("open", "settled", "archived")


class LoanRepaymentCreate(BaseModel):
    amount: Decimal
    date: _Date
    note: Optional[str] = None
    # Link to an existing transaction so it reconciles with the account
    # ledger, or leave unset for a purely manual entry (e.g. cash handed
    # over with no bank record). Both are first-class.
    transaction_id: Optional[uuid.UUID] = None


class LoanRepaymentRead(BaseModel):
    id: uuid.UUID
    loan_id: uuid.UUID
    amount: Decimal
    date: _Date
    note: Optional[str] = None
    transaction_id: Optional[uuid.UUID] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class LoanCreate(BaseModel):
    person_name: str
    payee_id: Optional[uuid.UUID] = None
    direction: str
    principal_amount: Decimal
    currency: str = "USD"
    date: _Date
    note: Optional[str] = None

    @field_validator("direction")
    @classmethod
    def validate_direction(cls, v: str) -> str:
        if v not in _DIRECTIONS:
            raise ValueError(f"direction must be one of {_DIRECTIONS}")
        return v


class LoanUpdate(BaseModel):
    person_name: Optional[str] = None
    payee_id: Optional[uuid.UUID] = None
    direction: Optional[str] = None
    principal_amount: Optional[Decimal] = None
    currency: Optional[str] = None
    date: Optional[_Date] = None
    note: Optional[str] = None
    status: Optional[str] = None

    @field_validator("direction")
    @classmethod
    def validate_direction(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and v not in _DIRECTIONS:
            raise ValueError(f"direction must be one of {_DIRECTIONS}")
        return v

    @field_validator("status")
    @classmethod
    def validate_status(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and v not in _STATUSES:
            raise ValueError(f"status must be one of {_STATUSES}")
        return v


class LoanRead(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    person_name: str
    payee_id: Optional[uuid.UUID] = None
    payee_name: Optional[str] = None
    direction: str
    principal_amount: Decimal
    currency: str
    date: _Date
    note: Optional[str] = None
    status: str
    created_at: datetime
    updated_at: datetime

    # Computed
    repaid_amount: Decimal = Decimal("0")
    remaining_amount: Decimal = Decimal("0")
    percentage: float = 0

    repayments: list[LoanRepaymentRead] = []

    model_config = ConfigDict(from_attributes=True)


class LoanSummary(BaseModel):
    """Dashboard-widget-sized totals, converted into the user's primary
    currency so mixed-currency loans still add up to one meaningful number."""
    total_owed_to_me: Decimal
    total_i_owe: Decimal
    currency: str
    open_count: int
