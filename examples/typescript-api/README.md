# TypeScript API Example

> Express 기반 REST API 예제

## 개요

이 예제는 Vibe Project Template을 TypeScript/Express 프로젝트에 적용한 실제 동작하는 API입니다.

## 기술 스택

- **Runtime**: Node.js 20+
- **Language**: TypeScript 5.x
- **Framework**: Express.js
- **Database**: SQLite (개발용) / PostgreSQL (프로덕션)
- **ORM**: Prisma
- **Validation**: Zod
- **Testing**: Jest

## 프로젝트 구조

```
typescript-api/
├── src/
│   ├── domain/           # 비즈니스 로직
│   │   └── user/
│   │       ├── entity.ts
│   │       ├── repository.ts
│   │       └── errors.ts
│   ├── application/      # 유스케이스
│   │   └── user/
│   │       ├── dto.ts
│   │       └── use-cases.ts
│   ├── infrastructure/   # 외부 연동
│   │   └── database/
│   │       ├── prisma.ts
│   │       └── user-repository.ts
│   ├── presentation/     # API 레이어
│   │   ├── routes/
│   │   │   └── user.routes.ts
│   │   ├── middleware/
│   │   │   ├── error-handler.ts
│   │   │   ├── request-logger.ts
│   │   │   └── validation.ts
│   │   └── app.ts
│   └── index.ts
├── tests/
│   └── unit/
│       └── domain/
├── prisma/
│   └── schema.prisma
├── CLAUDE.md             # 프로젝트별 AI 지시
├── package.json
├── jest.config.js
├── tsconfig.json
└── .env.example
```

## 시작하기

### 1. 의존성 설치

```bash
cd examples/typescript-api
npm install
```

### 2. 환경 설정

```bash
cp .env.example .env
```

### 3. 데이터베이스 초기화

```bash
npx prisma migrate dev
```

### 4. 개발 서버 실행

```bash
npm run dev
```

서버가 `http://localhost:3000`에서 실행됩니다.

## API 엔드포인트

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /health | 헬스 체크 |
| GET | /api/users | 사용자 목록 |
| POST | /api/users | 사용자 생성 |
| GET | /api/users/:id | 사용자 조회 |
| PUT | /api/users/:id | 사용자 수정 |
| DELETE | /api/users/:id | 사용자 삭제 |

## AI Agent 활용

### CLAUDE.md 활용

이 프로젝트의 `CLAUDE.md`는 상위 템플릿을 상속받아 프로젝트 특화 지침을 추가합니다.

```markdown
# 상속
@import ../../CLAUDE.md

# 프로젝트 특화 지침
...
```

### 예제 프롬프트

```
/test src/domain/user/service.ts
→ UserService에 대한 단위 테스트 생성

/review src/presentation/routes/user.ts
→ 라우터 코드 리뷰

/doc src/domain/user/entity.ts
→ User 엔터티 문서화
```

## 테스트

```bash
# 전체 테스트
npm test

# 커버리지
npm run test:coverage

# Watch 모드
npm run test:watch
```

## 빌드 & 배포

```bash
# 빌드
npm run build

# 프로덕션 실행
npm start
```

## 참고

- [루트 템플릿 문서](../../docs/)
- [커스터마이징 가이드](../../docs/guides/customization.md)
