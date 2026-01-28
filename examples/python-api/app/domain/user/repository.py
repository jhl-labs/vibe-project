"""User Repository Interface."""

from abc import ABC, abstractmethod

from app.domain.user.entity import User


class IUserRepository(ABC):
    """
    User Repository Interface.

    Defines the contract for user persistence operations.
    Implementation is in the infrastructure layer.
    """

    @abstractmethod
    async def find_by_id(self, user_id: str) -> User | None:
        """Find user by ID."""
        ...

    @abstractmethod
    async def find_by_email(self, email: str) -> User | None:
        """Find user by email."""
        ...

    @abstractmethod
    async def find_all(
        self,
        limit: int = 20,
        offset: int = 0,
        status: str | None = None,
    ) -> list[User]:
        """Find all users with pagination."""
        ...

    @abstractmethod
    async def save(self, user: User) -> User:
        """Save user (create or update)."""
        ...

    @abstractmethod
    async def delete(self, user_id: str) -> None:
        """Delete user."""
        ...

    @abstractmethod
    async def count(self, status: str | None = None) -> int:
        """Count users."""
        ...
