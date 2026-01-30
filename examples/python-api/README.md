# Python API Example

> FastAPI 기반 REST API 예제

## 개요

이 예제는 Vibe Project Template을 Python/FastAPI 프로젝트에 적용한 실제 동작하는 API입니다.

## 기술 스택

- **Runtime**: Python 3.11+
- **Framework**: FastAPI
- **ORM**: SQLAlchemy 2.0
- **Database**: SQLite (개발용) / PostgreSQL (프로덕션)
- **Validation**: Pydantic v2
- **Testing**: pytest

## 프로젝트 구조

```
python-api/
├── app/
│   ├── domain/           # 비즈니스 로직
│   │   └── user/
│   │       ├── entity.py
│   │       ├── repository.py
│   │       └── errors.py
│   ├── application/      # 유스케이스
│   │   └── user/
│   │       ├── dtos.py
│   │       └── use_cases.py
│   ├── infrastructure/   # 외부 연동
│   │   └── database/
│   │       ├── models.py
│   │       └── user_repository.py
│   ├── presentation/     # API 레이어
│   │   ├── api/
│   │   │   ├── deps.py
│   │   │   └── users.py
│   │   └── schemas/
│   │       └── user.py
│   ├── core/             # 설정
│   │   ├── config.py
│   │   └── database.py
│   └── main.py
├── tests/
│   └── unit/
│       └── domain/
├── CLAUDE.md             # 프로젝트별 AI 지시
├── pyproject.toml
├── requirements.txt
└── .env.example
```

## 시작하기

### 1. 가상 환경 설정

```bash
cd examples/python-api
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 2. 의존성 설치

```bash
pip install -r requirements.txt
```

### 3. 환경 설정

```bash
cp .env.example .env
```

### 4. 개발 서버 실행

```bash
uvicorn app.main:app --reload
```

서버가 `http://localhost:8000`에서 실행됩니다.

## API 문서

FastAPI는 자동으로 API 문서를 생성합니다:

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## API 엔드포인트

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /health | 헬스 체크 |
| GET | /api/v1/users | 사용자 목록 |
| POST | /api/v1/users | 사용자 생성 |
| GET | /api/v1/users/{id} | 사용자 조회 |
| PUT | /api/v1/users/{id} | 사용자 수정 |
| DELETE | /api/v1/users/{id} | 사용자 삭제 |

## AI Agent 활용

### 예제 프롬프트

```
/test app/domain/user/service.py
→ UserService에 대한 단위 테스트 생성

/review app/presentation/api/users.py
→ API 라우터 코드 리뷰

/doc app/domain/user/entity.py
→ User 엔터티 문서화
```

## 테스트

```bash
# 전체 테스트
pytest

# 커버리지
pytest --cov=app --cov-report=html

# 특정 테스트
pytest tests/unit/domain/user/
```

## 코드 품질

```bash
# Ruff (린터 + 포매터)
ruff check app
ruff format app

# Type check
mypy app
```

## 참고

- [루트 템플릿 문서](../../docs/)
- [커스터마이징 가이드](../../docs/guides/customization.md)
