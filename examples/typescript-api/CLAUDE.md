# CLAUDE.md - TypeScript API Example

> 이 프로젝트의 AI Agent 지시사항

## 상위 템플릿 참조

이 프로젝트는 Vibe Project Template을 기반으로 합니다.
공통 규칙은 `../../CLAUDE.md`를 참조하세요.

---

## 프로젝트 개요

이 프로젝트는 **TypeScript Express REST API** 예제입니다.
클린 아키텍처 원칙을 따르며, Prisma ORM을 사용합니다.

## 기술 스택

- **언어**: TypeScript 5.x (strict mode)
- **런타임**: Node.js 20+
- **프레임워크**: Express.js
- **ORM**: Prisma
- **검증**: Zod
- **테스트**: Jest + Supertest

## 아키텍처

### 레이어 구조

```
src/
├── domain/           # 핵심 비즈니스 로직 (순수 TypeScript)
├── application/      # 유스케이스 (도메인 조합)
├── infrastructure/   # 외부 연동 (DB, API 등)
└── presentation/     # HTTP 레이어 (Express)
```

### 의존성 규칙

```
Presentation → Application → Domain
                    ↓
              Infrastructure
```

- Domain은 외부 의존성 없음 (순수 함수/클래스)
- Application은 Domain만 의존
- Infrastructure는 Domain 인터페이스 구현
- Presentation은 Application 유스케이스 호출

## 코딩 컨벤션

### 파일 명명

```
# 파일명: kebab-case
user-service.ts
create-user.use-case.ts

# 클래스명: PascalCase
export class UserService { }
export class CreateUserUseCase { }
```

### 디렉토리별 파일 구조

```typescript
// domain/user/
entity.ts       // User 엔터티
repository.ts   // IUserRepository 인터페이스
service.ts      // UserService (도메인 서비스)
errors.ts       // 도메인 에러

// application/user/
use-cases.ts    // CreateUser, GetUser 등 유스케이스
dto.ts          // 입출력 DTO

// presentation/routes/
user.routes.ts  // Express 라우터
```

### 에러 처리

```typescript
// 도메인 에러
export class UserNotFoundError extends Error {
  constructor(id: string) {
    super(`User not found: ${id}`);
    this.name = 'UserNotFoundError';
  }
}

// 에러 핸들러 미들웨어에서 처리
```

### 검증

```typescript
// Zod 스키마 사용
import { z } from 'zod';

export const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
});

export type CreateUserInput = z.infer<typeof createUserSchema>;
```

## 주요 명령어

```bash
npm run dev          # 개발 서버
npm run build        # 빌드
npm test            # 테스트
npm run lint        # 린트
npm run db:migrate  # DB 마이그레이션
```

## AI 지침

### 코드 생성 시

1. 클린 아키텍처 레이어 준수
2. Zod로 입력 검증
3. 도메인 에러 클래스 사용
4. 비동기는 async/await

### 테스트 생성 시

1. 유닛 테스트: `tests/unit/`
2. 통합 테스트: `tests/integration/`
3. Jest + ts-jest 사용
4. 모킹은 jest.mock 사용

### 문서화 시

1. 공개 함수/클래스에 JSDoc
2. 복잡한 로직에 인라인 주석
3. API 엔드포인트는 OpenAPI 스타일 주석

## 참고 파일

- `prisma/schema.prisma` - DB 스키마
- `src/presentation/middleware/error-handler.ts` - 에러 처리
- `src/infrastructure/database/prisma.ts` - DB 클라이언트
