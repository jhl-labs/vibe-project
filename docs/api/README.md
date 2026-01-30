# API Documentation

> API 문서 보관소

## 개요

이 디렉토리에는 프로젝트의 API 문서가 포함됩니다.

## 문서 구조

```
docs/api/
├── README.md           # 이 파일
└── README.md           # 이 파일 (API 개요, 인증, 에러 코드 포함)
# 프로젝트 확장 시 아래 파일 추가 가능:
# ├── authentication.md   # 인증 가이드
# ├── errors.md           # 에러 코드 정의
# └── endpoints/          # 엔드포인트별 문서
```

## API 개요

### Base URL

```
Production: https://api.example.com/v1
Staging:    https://api-staging.example.com/v1
Development: http://localhost:3000/v1
```

### 인증

모든 API 요청에는 인증이 필요합니다 (일부 공개 엔드포인트 제외).

```bash
curl -H "Authorization: Bearer <token>" \
  https://api.example.com/v1/users
```

<!-- 인증 가이드를 별도 파일로 작성 시 링크 활성화:
자세한 내용은 [authentication.md](./authentication.md)를 참조하세요.
-->

### 요청 형식

- Content-Type: `application/json`
- Accept: `application/json`

### 응답 형식

모든 응답은 다음 형식을 따릅니다:

#### 성공 응답

```json
{
  "data": {
    // 응답 데이터
  },
  "meta": {
    "requestId": "req_123abc",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```

#### 에러 응답

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid email format",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address"
      }
    ]
  },
  "meta": {
    "requestId": "req_123abc",
    "timestamp": "2024-01-01T00:00:00Z"
  }
}
```

### 페이지네이션

목록 API는 커서 기반 페이지네이션을 사용합니다:

```bash
GET /api/v1/users?limit=20&cursor=abc123
```

응답:

```json
{
  "data": [...],
  "meta": {
    "pagination": {
      "limit": 20,
      "hasMore": true,
      "nextCursor": "def456"
    }
  }
}
```

### Rate Limiting

| 플랜 | 제한 |
|------|------|
| Free | 100 requests/minute |
| Pro | 1000 requests/minute |
| Enterprise | Custom |

Rate limit 헤더:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

### 버전 관리

API 버전은 URL 경로에 포함됩니다:

```
https://api.example.com/v1/users
https://api.example.com/v2/users
```

## 엔드포인트 목록

### Users

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /users | 사용자 목록 조회 |
| POST | /users | 사용자 생성 |
| GET | /users/:id | 사용자 상세 조회 |
| PUT | /users/:id | 사용자 수정 |
| DELETE | /users/:id | 사용자 삭제 |

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/login | 로그인 |
| POST | /auth/logout | 로그아웃 |
| POST | /auth/refresh | 토큰 갱신 |

## API 클라이언트

### cURL

```bash
curl -X POST https://api.example.com/v1/users \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "name": "John"}'
```

### JavaScript

```javascript
const response = await fetch('https://api.example.com/v1/users', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    email: 'user@example.com',
    name: 'John',
  }),
});
```

### Python

```python
import requests

response = requests.post(
    'https://api.example.com/v1/users',
    headers={'Authorization': f'Bearer {token}'},
    json={'email': 'user@example.com', 'name': 'John'}
)
```

## 에러 코드

| Code | HTTP Status | Description |
|------|-------------|-------------|
| VALIDATION_ERROR | 400 | 입력 검증 실패 |
| UNAUTHORIZED | 401 | 인증 필요 |
| FORBIDDEN | 403 | 권한 없음 |
| NOT_FOUND | 404 | 리소스 없음 |
| CONFLICT | 409 | 중복 리소스 |
| RATE_LIMIT | 429 | 요청 제한 초과 |
| INTERNAL_ERROR | 500 | 서버 오류 |

<!-- 에러 코드 상세 문서 작성 시 링크 활성화:
자세한 에러 코드는 [errors.md](./errors.md)를 참조하세요.
-->

## 변경 이력

| 버전 | 날짜 | 변경 내용 |
|------|------|----------|
| v1.0.0 | 2024-01-01 | 초기 릴리스 |

---

**Note**: 이 문서는 프로젝트에 맞게 업데이트해주세요.
