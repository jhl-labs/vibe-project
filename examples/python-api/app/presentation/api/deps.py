"""API Dependencies - Dependency Injection."""

from collections.abc import AsyncGenerator

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.application.user import UserUseCases
from app.infrastructure.database import SQLAlchemyUserRepository


async def get_user_use_cases(
    session: AsyncSession = Depends(get_session),
) -> AsyncGenerator[UserUseCases, None]:
    """Get user use cases with dependencies injected."""
    repository = SQLAlchemyUserRepository(session)
    yield UserUseCases(repository)
