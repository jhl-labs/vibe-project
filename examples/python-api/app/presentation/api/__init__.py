"""API routes"""

from fastapi import APIRouter

from app.presentation.api.users import router as users_router

router = APIRouter()

router.include_router(users_router, prefix="/users", tags=["users"])
