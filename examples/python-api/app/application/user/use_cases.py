"""User Use Cases."""

from app.domain.user import (
    IUserRepository,
    User,
    UserAlreadyExistsError,
    UserNotFoundError,
)
from app.presentation.schemas.user import (
    CreateUserRequest,
    UpdateUserRequest,
    UserResponse,
    UserListResponse,
)


class UserUseCases:
    """User use cases - application business logic."""

    def __init__(self, user_repository: IUserRepository) -> None:
        self._user_repository = user_repository

    async def create_user(self, request: CreateUserRequest) -> UserResponse:
        """Create a new user."""
        # Check for duplicate email
        existing = await self._user_repository.find_by_email(request.email)
        if existing:
            raise UserAlreadyExistsError(request.email)

        # Create user
        user = User.create(email=request.email, name=request.name)

        # Save
        saved = await self._user_repository.save(user)

        return self._to_response(saved)

    async def get_user(self, user_id: str) -> UserResponse:
        """Get user by ID."""
        user = await self._user_repository.find_by_id(user_id)
        if not user:
            raise UserNotFoundError(user_id)

        return self._to_response(user)

    async def list_users(
        self,
        limit: int = 20,
        offset: int = 0,
        status: str | None = None,
    ) -> UserListResponse:
        """List users with pagination."""
        users, total = await self._fetch_users_with_count(limit, offset, status)

        return UserListResponse(
            data=[self._to_response(user) for user in users],
            total=total,
            limit=limit,
            offset=offset,
        )

    async def update_user(
        self, user_id: str, request: UpdateUserRequest
    ) -> UserResponse:
        """Update user."""
        user = await self._user_repository.find_by_id(user_id)
        if not user:
            raise UserNotFoundError(user_id)

        # Check email uniqueness if changing
        if request.email and request.email != user.email:
            existing = await self._user_repository.find_by_email(request.email)
            if existing:
                raise UserAlreadyExistsError(request.email)

        # Update
        updated = user.update(email=request.email, name=request.name)
        saved = await self._user_repository.save(updated)

        return self._to_response(saved)

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

    def _to_response(self, user: User) -> UserResponse:
        """Convert domain entity to response."""
        return UserResponse(
            id=user.id,
            email=user.email,
            name=user.name,
            status=user.status.value,
            created_at=user.created_at,
            updated_at=user.updated_at,
        )
