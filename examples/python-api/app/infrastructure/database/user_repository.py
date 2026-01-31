"""SQLAlchemy User Repository Implementation."""

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.domain.user import User, UserStatus, IUserRepository
from app.infrastructure.database.models import UserModel


class SQLAlchemyUserRepository(IUserRepository):
    """SQLAlchemy implementation of user repository."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def find_by_id(self, user_id: str) -> User | None:
        """Find user by ID."""
        result = await self._session.execute(
            select(UserModel).where(UserModel.id == user_id)
        )
        model = result.scalar_one_or_none()
        return self._to_entity(model) if model else None

    async def find_by_email(self, email: str) -> User | None:
        """Find user by email."""
        result = await self._session.execute(
            select(UserModel).where(UserModel.email == email)
        )
        model = result.scalar_one_or_none()
        return self._to_entity(model) if model else None

    async def find_all(
        self,
        limit: int = 20,
        offset: int = 0,
        status: str | None = None,
    ) -> list[User]:
        """Find all users with pagination."""
        query = select(UserModel).order_by(UserModel.created_at.desc())

        if status:
            query = query.where(UserModel.status == status)

        query = query.limit(limit).offset(offset)

        result = await self._session.execute(query)
        models = result.scalars().all()

        return [self._to_entity(model) for model in models]

    async def save(self, user: User) -> User:
        """Save user (create or update)."""
        # Check if exists
        existing = await self._session.get(UserModel, user.id)

        if existing:
            # Update
            existing.email = user.email
            existing.name = user.name
            existing.status = user.status.value
            existing.updated_at = user.updated_at
        else:
            # Create
            model = UserModel(
                id=user.id,
                email=user.email,
                name=user.name,
                status=user.status.value,
                created_at=user.created_at,
                updated_at=user.updated_at,
            )
            self._session.add(model)

        await self._session.commit()

        # Refresh and return
        result = await self._session.execute(
            select(UserModel).where(UserModel.id == user.id)
        )
        saved_model = result.scalar_one()
        return self._to_entity(saved_model)

    async def delete(self, user_id: str) -> None:
        """Delete user."""
        model = await self._session.get(UserModel, user_id)
        if model:
            self._session.delete(model)
            await self._session.commit()

    async def count(self, status: str | None = None) -> int:
        """Count users."""
        query = select(func.count(UserModel.id))

        if status:
            query = query.where(UserModel.status == status)

        result = await self._session.execute(query)
        return result.scalar_one()

    def _to_entity(self, model: UserModel) -> User:
        """Convert model to domain entity."""
        return User(
            id=model.id,
            email=model.email,
            name=model.name,
            status=UserStatus(model.status),
            created_at=model.created_at,
            updated_at=model.updated_at,
        )
