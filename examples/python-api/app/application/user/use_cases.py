"""User Use Cases."""

from app.application.user.dtos import (
    CreateUserInput,
    UpdateUserInput,
    UserOutput,
    UserListOutput,
)
from app.domain.user import (
    IUserRepository,
    User,
    UserAlreadyExistsError,
    UserNotFoundError,
)


class UserUseCases:
    """User use cases - application business logic."""

    def __init__(self, user_repository: IUserRepository) -> None:
        self._user_repository = user_repository

    async def create_user(self, input_dto: CreateUserInput) -> UserOutput:
        """Create a new user."""
        # Check for duplicate email
        existing = await self._user_repository.find_by_email(input_dto.email)
        if existing:
            raise UserAlreadyExistsError(input_dto.email)

        # Create user
        user = User.create(email=input_dto.email, name=input_dto.name)

        # Save
        saved = await self._user_repository.save(user)

        return self._to_output(saved)

    async def get_user(self, user_id: str) -> UserOutput:
        """Get user by ID."""
        user = await self._user_repository.find_by_id(user_id)
        if not user:
            raise UserNotFoundError(user_id)

        return self._to_output(user)

    async def list_users(
        self,
        limit: int = 20,
        offset: int = 0,
        status: str | None = None,
    ) -> UserListOutput:
        """List users with pagination."""
        users, total = await self._fetch_users_with_count(limit, offset, status)

        return UserListOutput(
            data=[self._to_output(user) for user in users],
            total=total,
            limit=limit,
            offset=offset,
        )

    async def update_user(
        self, user_id: str, input_dto: UpdateUserInput
    ) -> UserOutput:
        """Update user."""
        user = await self._user_repository.find_by_id(user_id)
        if not user:
            raise UserNotFoundError(user_id)

        # Check email uniqueness if changing
        if input_dto.email and input_dto.email != user.email:
            existing = await self._user_repository.find_by_email(input_dto.email)
            if existing:
                raise UserAlreadyExistsError(input_dto.email)

        # Update
        updated = user.update(email=input_dto.email, name=input_dto.name)
        saved = await self._user_repository.save(updated)

        return self._to_output(saved)

    async def delete_user(self, user_id: str) -> None:
        """Delete user."""
        user = await self._user_repository.find_by_id(user_id)
        if not user:
            raise UserNotFoundError(user_id)

        await self._user_repository.delete(user_id)

    async def _fetch_users_with_count(
        self,
        limit: int,
        offset: int,
        status: str | None,
    ) -> tuple[list[User], int]:
        """Fetch users and count concurrently."""
        users = await self._user_repository.find_all(
            limit=limit, offset=offset, status=status
        )
        total = await self._user_repository.count(status=status)
        return users, total

    def _to_output(self, user: User) -> UserOutput:
        """Convert domain entity to output DTO."""
        return UserOutput(
            id=user.id,
            email=user.email,
            name=user.name,
            status=user.status.value,
            created_at=user.created_at,
            updated_at=user.updated_at,
        )
