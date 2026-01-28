"""User Domain Errors."""


class UserNotFoundError(Exception):
    """Raised when user is not found."""

    def __init__(self, identifier: str) -> None:
        super().__init__(f"User not found: {identifier}")
        self.identifier = identifier


class UserAlreadyExistsError(Exception):
    """Raised when user already exists."""

    def __init__(self, email: str) -> None:
        super().__init__(f"User with email '{email}' already exists")
        self.email = email
