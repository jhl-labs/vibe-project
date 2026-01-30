"""User Application DTOs.

Application layer data transfer objects.
These are used by use cases to receive input and return output,
keeping the application layer independent of the presentation layer.
"""

from dataclasses import dataclass
from datetime import datetime


@dataclass(frozen=True)
class CreateUserInput:
    """Input DTO for creating a user."""

    email: str
    name: str


@dataclass(frozen=True)
class UpdateUserInput:
    """Input DTO for updating a user."""

    email: str | None = None
    name: str | None = None


@dataclass(frozen=True)
class UserOutput:
    """Output DTO for a single user."""

    id: str
    email: str
    name: str
    status: str
    created_at: datetime
    updated_at: datetime


@dataclass(frozen=True)
class UserListOutput:
    """Output DTO for a list of users."""

    data: list[UserOutput]
    total: int
    limit: int
    offset: int
