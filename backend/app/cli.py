"""CLI commands for managing the application."""
import asyncio
import sys
import uuid

from sqlalchemy import select

from app.core.database import async_session_maker
from app.models.user import User


async def generate_recurring() -> None:
    """Generate pending recurring transactions for all users."""
    from app.models.user import User as UserModel
    from app.services import recurring_transaction_service

    async with async_session_maker() as session:
        result = await session.execute(select(UserModel))
        users = result.scalars().all()
        total = 0
        for user in users:
            count = await recurring_transaction_service.generate_pending(session, user.id)
            if count > 0:
                print(f"Generated {count} transactions for {user.email}")
                total += count
        print(f"Total generated: {total}")


async def create_user(email: str, password: str) -> None:
    """Create a new user with the given email and password."""
    from pwdlib import PasswordHash

    hasher = PasswordHash.recommended()

    async with async_session_maker() as session:
        # Check if user already exists
        result = await session.execute(select(User).where(User.email == email))
        existing = result.scalar_one_or_none()
        if existing:
            print(f"Error: User with email '{email}' already exists.")
            sys.exit(1)

        user = User(
            id=uuid.uuid4(),
            email=email,
            hashed_password=hasher.hash(password),
            is_active=True,
            is_superuser=False,
            is_verified=True,
            preferences={
                "language": "pt-BR",
                "date_format": "DD/MM/YYYY",
                "timezone": "America/Sao_Paulo",
                "currency_display": "USD",
            },
        )
        session.add(user)
        await session.commit()
        print(f"User created successfully: {email}")


async def reset_password(email: str, password: str) -> None:
    """Set a new password for an existing user (local accounts only)."""
    from pwdlib import PasswordHash

    hasher = PasswordHash.recommended()

    async with async_session_maker() as session:
        result = await session.execute(select(User).where(User.email == email))
        user = result.scalar_one_or_none()
        if not user:
            print(f"Error: No user with email '{email}'.")
            sys.exit(1)

        user.hashed_password = hasher.hash(password)
        await session.commit()
        print(f"Password reset for: {email}")


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python -m app.cli create-user <email> <password>")
        print("  python -m app.cli reset-password <email> <new-password>")
        sys.exit(1)

    command = sys.argv[1]

    if command == "create-user":
        if len(sys.argv) != 4:
            print("Usage: python -m app.cli create-user <email> <password>")
            sys.exit(1)
        email, password = sys.argv[2], sys.argv[3]
        asyncio.run(create_user(email, password))
    elif command == "reset-password":
        if len(sys.argv) != 4:
            print("Usage: python -m app.cli reset-password <email> <new-password>")
            sys.exit(1)
        email, password = sys.argv[2], sys.argv[3]
        asyncio.run(reset_password(email, password))
    elif command == "generate-recurring":
        asyncio.run(generate_recurring())
    else:
        print(f"Unknown command: {command}")
        print("Available commands: create-user, reset-password, generate-recurring")
        sys.exit(1)


if __name__ == "__main__":
    main()
