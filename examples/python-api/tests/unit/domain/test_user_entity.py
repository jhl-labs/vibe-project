"""User Entity Unit Tests."""

import pytest

from app.domain.user.entity import User, UserStatus


class TestUserEntity:
    """Test cases for User entity."""

    def test_create_user(self) -> None:
        """Should create a user with active status."""
        user = User.create(email="test@example.com", name="Test User")

        assert user.email == "test@example.com"
        assert user.name == "Test User"
        assert user.status == UserStatus.ACTIVE
        assert user.is_active is True
        assert user.id is not None

    def test_create_sets_timestamps(self) -> None:
        """Should set timestamps on creation."""
        user = User.create(email="test@example.com", name="Test")

        assert user.created_at is not None
        assert user.updated_at is not None

    def test_update_name(self) -> None:
        """Should update name."""
        user = User.create(email="test@example.com", name="Original")
        updated = user.update(name="Updated")

        assert updated.name == "Updated"
        assert updated.email == "test@example.com"

    def test_update_email(self) -> None:
        """Should update email."""
        user = User.create(email="original@example.com", name="Test")
        updated = user.update(email="updated@example.com")

        assert updated.email == "updated@example.com"

    def test_deactivate(self) -> None:
        """Should change status to inactive."""
        user = User.create(email="test@example.com", name="Test")
        deactivated = user.deactivate()

        assert deactivated.status == UserStatus.INACTIVE
        assert deactivated.is_active is False

    def test_deactivate_already_inactive_raises(self) -> None:
        """Should raise error if already inactive."""
        user = User.create(email="test@example.com", name="Test")
        deactivated = user.deactivate()

        with pytest.raises(ValueError, match="already inactive"):
            deactivated.deactivate()

    def test_activate(self) -> None:
        """Should change status to active."""
        user = User.create(email="test@example.com", name="Test")
        deactivated = user.deactivate()
        activated = deactivated.activate()

        assert activated.status == UserStatus.ACTIVE
        assert activated.is_active is True

    def test_activate_already_active_raises(self) -> None:
        """Should raise error if already active."""
        user = User.create(email="test@example.com", name="Test")

        with pytest.raises(ValueError, match="already active"):
            user.activate()
