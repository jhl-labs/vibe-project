"""User API Routes."""

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.application.user import (
    CreateUserInput,
    UpdateUserInput,
    UserUseCases,
)
from app.domain.user import UserNotFoundError, UserAlreadyExistsError
from app.presentation.api.deps import get_user_use_cases
from app.presentation.schemas.user import (
    CreateUserRequest,
    UpdateUserRequest,
    UserResponse,
    UserListResponse,
)

router = APIRouter()


@router.get("", response_model=UserListResponse)
async def list_users(
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    status: str | None = Query(None),
    use_cases: UserUseCases = Depends(get_user_use_cases),
) -> UserListResponse:
    """
    List users with pagination.

    - **limit**: Maximum number of users to return (1-100)
    - **offset**: Number of users to skip
    - **status**: Filter by status (active, inactive, suspended)
    """
    result = await use_cases.list_users(limit=limit, offset=offset, status=status)
    return UserListResponse(
        data=[UserResponse(**vars(u)) for u in result.data],
        total=result.total,
        limit=result.limit,
        offset=result.offset,
    )


@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    request: CreateUserRequest,
    use_cases: UserUseCases = Depends(get_user_use_cases),
) -> UserResponse:
    """
    Create a new user.

    - **email**: User's email address (must be unique)
    - **name**: User's display name
    """
    try:
        result = await use_cases.create_user(
            CreateUserInput(email=request.email, name=request.name)
        )
        return UserResponse(**vars(result))
    except UserAlreadyExistsError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=str(e),
        )


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: str,
    use_cases: UserUseCases = Depends(get_user_use_cases),
) -> UserResponse:
    """Get user by ID."""
    try:
        result = await use_cases.get_user(user_id)
        return UserResponse(**vars(result))
    except UserNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )


@router.put("/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: str,
    request: UpdateUserRequest,
    use_cases: UserUseCases = Depends(get_user_use_cases),
) -> UserResponse:
    """Update user."""
    try:
        result = await use_cases.update_user(
            user_id,
            UpdateUserInput(email=request.email, name=request.name),
        )
        return UserResponse(**vars(result))
    except UserNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )
    except UserAlreadyExistsError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=str(e),
        )


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    user_id: str,
    use_cases: UserUseCases = Depends(get_user_use_cases),
) -> None:
    """Delete user."""
    try:
        await use_cases.delete_user(user_id)
    except UserNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e),
        )
