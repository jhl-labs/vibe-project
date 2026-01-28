# CLAUDE.md - Python API Example

> 이 프로젝트의 AI Agent 지시사항

## 상위 템플릿 참조

이 프로젝트는 Vibe Project Template을 기반으로 합니다.
공통 규칙은 `../../CLAUDE.md`를 참조하세요.

---

## 프로젝트 개요

이 프로젝트는 **Python FastAPI REST API** 예제입니다.
클린 아키텍처 원칙을 따르며, SQLAlchemy ORM을 사용합니다.

## 기술 스택

- **언어**: Python 3.11+
- **프레임워크**: FastAPI
- **ORM**: SQLAlchemy 2.0 (async)
- **검증**: Pydantic v2
- **테스트**: pytest + pytest-asyncio

## 아키텍처

### 레이어 구조

```
app/
├── domain/           # 핵심 비즈니스 로직 (순수 Python)
├── application/      # 유스케이스 (도메인 조합)
├── infrastructure/   # 외부 연동 (DB, API 등)
├── presentation/     # HTTP 레이어 (FastAPI)
└── core/             # 설정, 유틸리티
```

### 의존성 규칙

- Domain은 외부 의존성 없음
- Application은 Domain만 의존
- Infrastructure는 Domain 인터페이스 구현
- Presentation은 Application 유스케이스 호출

## 코딩 컨벤션

### 파일 명명

```python
# 파일명: snake_case
user_service.py
create_user_use_case.py

# 클래스명: PascalCase
class UserService:
    pass
```

### 타입 힌트

```python
# 모든 함수에 타입 힌트 필수
def get_user(user_id: str) -> User | None:
    pass

async def create_user(data: CreateUserInput) -> User:
    pass
```

### Docstring

```python
def calculate_discount(amount: float, rate: float) -> float:
    """
    할인 금액을 계산합니다.

    Args:
        amount: 원래 금액
        rate: 할인율 (0.0 ~ 1.0)

    Returns:
        할인된 금액

    Raises:
        ValueError: rate가 유효 범위를 벗어난 경우
    """
    pass
```

### 에러 처리

```python
# 도메인 에러
class UserNotFoundError(Exception):
    def __init__(self, user_id: str):
        super().__init__(f"User not found: {user_id}")

# FastAPI exception handler에서 처리
```

## 주요 명령어

```bash
uvicorn app.main:app --reload  # 개발 서버
pytest                          # 테스트
ruff check app                  # 린트
ruff format app                 # 포매팅
mypy app                        # 타입 체크
```

## AI 지침

### 코드 생성 시

1. 클린 아키텍처 레이어 준수
2. Pydantic으로 입력/출력 스키마 정의
3. async/await 사용 (DB 작업)
4. 타입 힌트 필수

### 테스트 생성 시

1. pytest 사용
2. async 테스트는 pytest-asyncio
3. fixture 활용
4. 모킹은 unittest.mock 또는 pytest-mock

### 문서화 시

1. Google style docstring
2. FastAPI의 자동 문서화 활용
3. Pydantic 스키마에 description 추가

## 참고 파일

- `app/core/config.py` - 설정
- `app/core/database.py` - DB 연결
- `app/presentation/api/deps.py` - 의존성 주입
