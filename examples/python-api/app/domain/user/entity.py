"""User Entity - Domain model."""

from dataclasses import dataclass, field
from datetime import datetime, timezone
from enum import Enum
from uuid import uuid4


def _utcnow() -> datetime:
    """Return current UTC time as timezone-aware datetime."""
    return datetime.now(timezone.utc)


class UserStatus(str, Enum):
    """User status enumeration."""

    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"


@dataclass
class User:
    """
    User domain entity.

    Encapsulates business rules and invariants.
    """

    id: str
    email: str
    name: str
    status: UserStatus = UserStatus.ACTIVE
    created_at: datetime = field(default_factory=_utcnow)
    updated_at: datetime = field(default_factory=_utcnow)

    @classmethod
    def create(cls, email: str, name: str) -> "User":
        """Create a new user."""
        now = _utcnow()
        return cls(
            id=str(uuid4()),
            email=email,
            name=name,
            status=UserStatus.ACTIVE,
            created_at=now,
            updated_at=now,
        )

    @property
    def is_active(self) -> bool:
        """Check if user is active."""
        return self.status == UserStatus.ACTIVE

    def update(self, email: str | None = None, name: str | None = None) -> "User":
        """Update user information."""
        return User(
            id=self.id,
            email=email if email is not None else self.email,
            name=name if name is not None else self.name,
            status=self.status,
            created_at=self.created_at,
            updated_at=_utcnow(),
        )

    def deactivate(self) -> "User":
        """Deactivate user."""
        if self.status == UserStatus.INACTIVE:
            raise ValueError("User is already inactive")
        return User(
            id=self.id,
            email=self.email,
            name=self.name,
            status=UserStatus.INACTIVE,
            created_at=self.created_at,
            updated_at=_utcnow(),
        )

    def activate(self) -> "User":
        """Activate user."""
        if self.status == UserStatus.ACTIVE:
            raise ValueError("User is already active")
        return User(
            id=self.id,
            email=self.email,
            name=self.name,
            status=UserStatus.ACTIVE,
            created_at=self.created_at,
            updated_at=_utcnow(),
        )
