# Documentation Generation Skill

> AI 에이전트의 문서 생성 가이드

## 문서화 원칙

### 문서의 목적

1. **사용자 가이드**: 사용 방법 안내
2. **개발자 참조**: API 및 구현 세부사항
3. **의사결정 기록**: 아키텍처 결정 근거
4. **온보딩**: 새 팀원 적응 지원

### 좋은 문서의 특징

- **정확성**: 최신 코드와 일치
- **완전성**: 필요한 정보 포함
- **명확성**: 이해하기 쉬운 설명
- **구조화**: 논리적 구성
- **검색 가능**: 찾기 쉬운 구조

## 문서 유형

### 1. API 문서

#### REST API

```markdown
## Create User

사용자를 생성합니다.

### Endpoint

`POST /api/v1/users`

### Request Headers

| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer token |
| Content-Type | Yes | application/json |

### Request Body

```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | Yes | User's email address |
| name | string | Yes | User's display name |
| role | string | No | User role (default: "user") |

### Response

#### Success (201 Created)

```json
{
  "id": "usr_123abc",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

#### Error Responses

| Status | Code | Description |
|--------|------|-------------|
| 400 | VALIDATION_ERROR | Invalid request body |
| 409 | DUPLICATE_EMAIL | Email already exists |
| 401 | UNAUTHORIZED | Missing or invalid token |

### Example

```bash
curl -X POST https://api.example.com/v1/users \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "name": "John Doe"}'
```
```

### 2. 코드 문서 (JSDoc/Docstring)

#### TypeScript/JavaScript

```typescript
/**
 * Creates a new user account.
 *
 * This function validates the input data, checks for duplicate emails,
 * and creates a new user in the database. A welcome email is sent
 * upon successful creation.
 *
 * @param data - The user creation data
 * @param options - Optional configuration
 * @returns The created user object
 *
 * @throws {ValidationError} When email format is invalid
 * @throws {DuplicateError} When email already exists
 * @throws {DatabaseError} When database operation fails
 *
 * @example
 * // Basic usage
 * const user = await createUser({
 *   email: 'user@example.com',
 *   name: 'John Doe'
 * });
 *
 * @example
 * // With options
 * const user = await createUser(
 *   { email: 'user@example.com', name: 'John' },
 *   { sendWelcomeEmail: false }
 * );
 *
 * @see {@link updateUser} for updating existing users
 * @since 1.0.0
 */
async function createUser(
  data: CreateUserInput,
  options?: CreateUserOptions
): Promise<User> {
  // implementation
}
```

#### Python

```python
def create_user(data: CreateUserInput, options: CreateUserOptions = None) -> User:
    """
    Creates a new user account.

    This function validates the input data, checks for duplicate emails,
    and creates a new user in the database. A welcome email is sent
    upon successful creation.

    Args:
        data: The user creation data containing email and name.
        options: Optional configuration for user creation.
            - send_welcome_email: Whether to send welcome email (default: True)
            - skip_validation: Skip email validation (default: False)

    Returns:
        User: The created user object with id, email, name, and timestamps.

    Raises:
        ValidationError: When email format is invalid.
        DuplicateError: When email already exists in the system.
        DatabaseError: When database operation fails.

    Example:
        Basic usage::

            user = create_user(CreateUserInput(
                email='user@example.com',
                name='John Doe'
            ))

        With options::

            user = create_user(
                CreateUserInput(email='user@example.com', name='John'),
                CreateUserOptions(send_welcome_email=False)
            )

    Note:
        Email addresses are normalized to lowercase before storage.

    See Also:
        update_user: For updating existing users.
        delete_user: For removing users.

    .. versionadded:: 1.0.0
    """
    pass
```

### 3. README

```markdown
# Project Name

> 한 줄 설명

[![CI](badge)](link)
[![Coverage](badge)](link)
[![License](badge)](link)

## Overview

프로젝트에 대한 간략한 설명 (2-3문장)

## Features

- 주요 기능 1
- 주요 기능 2
- 주요 기능 3

## Quick Start

### Prerequisites

- Node.js >= 18
- PostgreSQL >= 14

### Installation

```bash
# Clone repository
git clone https://github.com/org/project.git
cd project

# Install dependencies
npm install

# Setup environment
cp .env.example .env

# Run database migrations
npm run db:migrate

# Start development server
npm run dev
```

### Usage

```typescript
import { Client } from 'project';

const client = new Client({ apiKey: 'your-api-key' });
const result = await client.doSomething();
```

## Documentation

- [API Reference](docs/api/)
- [Development Guide](docs/guides/development.md)
- [Architecture](docs/adr/)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT - see [LICENSE](LICENSE)
```

### 4. ADR (Architecture Decision Record)

```markdown
# ADR-001: Use PostgreSQL as Primary Database

## Status

Accepted

## Date

2024-01-15

## Context

우리 애플리케이션은 다음과 같은 데이터 저장소 요구사항이 있습니다:
- 복잡한 관계형 데이터 모델
- 트랜잭션 지원
- JSON 데이터 타입 지원
- 전문 검색 기능

## Decision

PostgreSQL 14+를 주 데이터베이스로 사용합니다.

## Considered Alternatives

### MySQL 8
- 장점: 더 넓은 호스팅 옵션
- 단점: JSON 지원이 PostgreSQL보다 약함

### MongoDB
- 장점: 스키마 유연성
- 단점: 복잡한 조인 쿼리 어려움, 트랜잭션 제한

## Consequences

### Positive
- 강력한 ACID 트랜잭션 지원
- 우수한 JSON/JSONB 지원
- 풍부한 확장 기능 (PostGIS, pg_trgm 등)

### Negative
- 팀원들의 PostgreSQL 학습 필요
- MySQL 대비 클라우드 호스팅 비용이 약간 높음

### Risks
- 특정 클라우드 제공자에 종속될 수 있음

## References

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Why PostgreSQL](https://www.postgresql.org/about/)
```

## 문서 템플릿

### 함수 문서

```
## [함수명]

[간단한 설명]

### Signature

```
[함수 시그니처]
```

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| param1 | type | Yes/No | 설명 |

### Returns

| Type | Description |
|------|-------------|
| type | 설명 |

### Throws

| Error | Condition |
|-------|-----------|
| ErrorType | 발생 조건 |

### Example

```
[사용 예시]
```

### Notes

- 주의사항 1
- 주의사항 2
```

### 클래스 문서

```
## [클래스명]

[클래스 설명]

### Constructor

```
[생성자 시그니처]
```

### Properties

| Name | Type | Description |
|------|------|-------------|
| prop1 | type | 설명 |

### Methods

#### method1

[메서드 설명]

### Example

```
[사용 예시]
```
```

## AI 문서 생성 출력 형식

```markdown
## 생성된 문서

### 파일: `docs/api/users.md`

[생성된 문서 내용]

### 업데이트 요약
- 새로 추가: 3개 엔드포인트
- 업데이트: 2개 엔드포인트
- 예시 코드: 5개 추가

### 검토 필요 항목
- [ ] 인증 섹션 내용 확인 필요
- [ ] 에러 코드 목록 검증 필요
```

---

**참고**: 문서는 코드와 함께 업데이트해야 합니다.
코드 변경 시 관련 문서도 확인하세요.
