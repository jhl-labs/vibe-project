# Coding Conventions

> 프로젝트의 코딩 규칙과 스타일 가이드

## 일반 원칙

### 코드 품질

1. **가독성 우선**: 영리한 코드보다 명확한 코드
2. **DRY (Don't Repeat Yourself)**: 중복 최소화
3. **KISS (Keep It Simple, Stupid)**: 단순함 유지
4. **YAGNI (You Aren't Gonna Need It)**: 필요한 것만 구현

### 함수 설계

- 한 함수는 하나의 작업만 수행
- 함수 길이는 20-30줄 이내 권장
- 파라미터는 3개 이내 권장
- 부수 효과(Side Effects) 최소화

## 네이밍 규칙

### 파일 & 디렉토리

```
# TypeScript/JavaScript: kebab-case
user-service.ts
api-client.js
database-config.ts

# Python: snake_case (PEP 8 준수)
user_service.py
api_client.py
database_config.py

# 테스트 파일
user-service.test.ts       # TS/JS
user-service.spec.ts       # TS/JS
test_user_service.py       # Python

# 디렉토리: kebab-case (TS/JS), snake_case (Python)
```

### 코드 요소

| 요소 | 규칙 | 예시 |
|------|------|------|
| 클래스 | PascalCase | `UserService`, `HttpClient` |
| 인터페이스 | PascalCase (I prefix 없이) | `UserRepository`, `UserService` |
| 타입 | PascalCase | `UserData`, `ApiResponse` |
| 함수/메서드 | camelCase | `getUserById`, `calculateTotal` |
| 변수 | camelCase | `userName`, `isActive` |
| 상수 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `API_BASE_URL` |
| Enum | PascalCase (값은 UPPER_SNAKE) | `UserRole.ADMIN` |
| Private | _prefix (언어별 상이) | `_internalState`, `__private` |

### 의미 있는 이름

```typescript
// Bad
const d = new Date();
const u = getUser();
const arr = [];

// Good
const createdAt = new Date();
const currentUser = getUser();
const activeUsers = [];
```

### Boolean 변수

```typescript
// is, has, can, should prefix 사용
const isActive = true;
const hasPermission = user.roles.includes('admin');
const canEdit = hasPermission && isOwner;
const shouldRefresh = isStale || forceRefresh;
```

## 코드 스타일

### 들여쓰기 & 포맷팅

```yaml
indent_style: space
indent_size: 2  # JS/TS, 4 for Python
max_line_length: 100
insert_final_newline: true
trim_trailing_whitespace: true
```

### 중괄호 스타일

```typescript
// K&R style (권장)
function example() {
  if (condition) {
    // code
  } else {
    // code
  }
}
```

### Import 순서

```typescript
// 1. 외부 라이브러리
import express from 'express';
import { Injectable } from '@nestjs/common';

// 2. 내부 모듈 (절대 경로)
import { UserService } from '@/services/user-service';
import { config } from '@/config';

// 3. 상대 경로
import { helper } from './helper';
import { types } from '../types';
```

## 타입 시스템 (TypeScript)

### 타입 정의

```typescript
// Interface for objects with methods
interface UserService {
  getUser(id: string): Promise<User>;
  createUser(data: CreateUserDto): Promise<User>;
}

// Type for data structures
type UserData = {
  id: string;
  name: string;
  email: string;
};

// Union types
type Status = 'pending' | 'active' | 'inactive';

// Generics
type ApiResponse<T> = {
  data: T;
  meta: ResponseMeta;
};
```

### Null 처리

```typescript
// Explicit null checks
function getUser(id: string): User | null {
  const user = repository.findById(id);
  return user ?? null;
}

// Optional chaining
const userName = user?.profile?.name;

// Nullish coalescing
const displayName = user.name ?? 'Anonymous';
```

## 에러 처리

### 에러 클래스

```typescript
// Custom error classes
class ApplicationError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'ApplicationError';
  }
}

class NotFoundError extends ApplicationError {
  constructor(resource: string, id: string) {
    super(`${resource} not found: ${id}`, 'NOT_FOUND', 404);
  }
}
```

### Try-Catch 패턴

```typescript
// Specific error handling
try {
  await userService.createUser(data);
} catch (error) {
  if (error instanceof ValidationError) {
    return res.status(400).json({ error: error.message });
  }
  if (error instanceof DuplicateError) {
    return res.status(409).json({ error: 'User already exists' });
  }
  // Re-throw unknown errors
  throw error;
}
```

## 비동기 코드

### Async/Await

```typescript
// Prefer async/await over .then()
async function fetchUserData(userId: string): Promise<UserData> {
  const user = await userRepository.findById(userId);
  if (!user) {
    throw new NotFoundError('User', userId);
  }

  const profile = await profileService.getProfile(userId);

  return {
    ...user,
    profile,
  };
}
```

### 병렬 처리

```typescript
// Parallel execution
const [user, permissions, settings] = await Promise.all([
  userService.getUser(id),
  permissionService.getPermissions(id),
  settingsService.getSettings(id),
]);

// With error handling
const results = await Promise.allSettled([
  fetchUser(id),
  fetchPermissions(id),
]);
```

## 주석

### 언제 주석을 작성할까

```typescript
// DO: 비즈니스 로직 설명
// 30일 이상 비활성 사용자는 휴면 처리
// (개인정보보호법 제39조의6에 따름)
if (daysSinceLastLogin > 30) {
  await markAsDormant(user);
}

// DO: 복잡한 알고리즘 설명
// Fisher-Yates shuffle algorithm
for (let i = array.length - 1; i > 0; i--) {
  const j = Math.floor(Math.random() * (i + 1));
  [array[i], array[j]] = [array[j], array[i]];
}

// DON'T: 코드 자체가 설명하는 것
// Get user by id
const user = getUserById(id);  // 불필요한 주석
```

### JSDoc / Docstring

```typescript
/**
 * Creates a new user account.
 *
 * @param data - User creation data
 * @returns Created user object
 * @throws {ValidationError} If email is invalid
 * @throws {DuplicateError} If email already exists
 *
 * @example
 * const user = await createUser({
 *   email: 'user@example.com',
 *   name: 'John Doe'
 * });
 */
async function createUser(data: CreateUserDto): Promise<User> {
  // implementation
}
```

## Git 규칙

### 커밋 메시지

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Types:**
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `style`: 코드 포맷팅 (기능 변경 없음)
- `refactor`: 리팩토링
- `test`: 테스트 추가/수정
- `chore`: 빌드, 설정 변경
- `perf`: 성능 개선
- `ci`: CI 설정 변경
- `build`: 빌드 시스템 변경

**예시:**
```
feat(auth): add JWT refresh token support

- Implement refresh token rotation
- Add token blacklist for logout
- Update auth middleware

Closes #123
```

### 브랜치 전략

```
main (production)
  └── develop
        ├── feature/user-auth
        ├── feature/payment-integration
        └── fix/login-bug
```

---

**참고**: 이 규칙은 프로젝트에 맞게 수정하세요.
언어/프레임워크별 추가 규칙은 해당 문서를 참조하세요.
