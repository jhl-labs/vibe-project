# Development Guide

> 개발 가이드 및 워크플로우

## 개발 환경

### 권장 IDE 설정

#### VS Code

```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "files.eol": "\n"
}
```

#### 권장 확장

- ESLint
- Prettier
- EditorConfig
- GitLens
- Error Lens
- Thunder Client (API 테스트)

### 환경 변수 관리

```bash
# 개발 환경
.env.development

# 테스트 환경
.env.test

# 프로덕션 환경 (템플릿)
.env.example
```

**주의**: `.env` 파일은 절대 커밋하지 마세요.

## 개발 워크플로우

### Git 브랜치 전략

```
main (production)
  └── develop
        ├── feature/ISSUE-123-add-user-auth
        ├── feature/ISSUE-456-payment-integration
        ├── fix/ISSUE-789-login-bug
        └── hotfix/critical-security-patch
```

### 브랜치 명명 규칙

```
<type>/<issue-number>-<short-description>

예시:
feature/ISSUE-123-add-user-authentication
fix/ISSUE-456-fix-login-redirect
hotfix/ISSUE-789-security-patch
refactor/ISSUE-101-improve-api-structure
```

### 개발 프로세스

```
1. 이슈 확인/생성
       ↓
2. 브랜치 생성
       ↓
3. 개발 & 테스트
       ↓
4. 커밋 (Conventional Commits)
       ↓
5. PR 생성
       ↓
6. 코드 리뷰
       ↓
7. CI 통과 확인
       ↓
8. Merge
```

## 코딩 규칙

### 코드 스타일

프로젝트의 코딩 컨벤션은 다음 파일에 정의되어 있습니다:

- `.editorconfig` - 에디터 설정
- `.eslintrc` - JavaScript/TypeScript 린트
- `.prettierrc` - 코드 포맷팅
- `CLAUDE.md` - AI 에이전트 지침

### 커밋 메시지

[Conventional Commits](https://www.conventionalcommits.org/) 형식을 사용합니다:

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

#### Types

| Type | 설명 | 예시 |
|------|------|------|
| feat | 새로운 기능 | feat(auth): add JWT authentication |
| fix | 버그 수정 | fix(login): resolve redirect issue |
| docs | 문서 변경 | docs: update API documentation |
| style | 포맷팅 (기능 변경 없음) | style: format code with prettier |
| refactor | 리팩토링 | refactor(api): simplify error handling |
| test | 테스트 추가/수정 | test(user): add unit tests |
| chore | 빌드/설정 변경 | chore: update dependencies |
| perf | 성능 개선 | perf(db): optimize query |

#### 예시

```bash
# 새 기능
git commit -m "feat(user): add password reset functionality

- Add forgot password endpoint
- Implement email verification
- Add password strength validation

Closes #123"

# 버그 수정
git commit -m "fix(auth): resolve token refresh race condition

The refresh token was being invalidated before the new token
was generated, causing intermittent logout issues.

Fixes #456"
```

### 코드 리뷰

#### PR 체크리스트

- [ ] 자체 코드 리뷰 완료
- [ ] 테스트 추가/수정
- [ ] 문서 업데이트 (필요시)
- [ ] 린트/타입 체크 통과
- [ ] 커밋 메시지 규칙 준수

#### 리뷰어 가이드라인

1. **기능**: 요구사항을 충족하는가?
2. **설계**: 아키텍처 원칙을 따르는가?
3. **가독성**: 이해하기 쉬운가?
4. **테스트**: 적절한 테스트가 있는가?
5. **보안**: 보안 취약점이 없는가?

## 테스트

### 테스트 전략

```
        ╱╲
       ╱  ╲         E2E Tests (10%)
      ╱────╲
     ╱      ╲       Integration Tests (20%)
    ╱────────╲
   ╱          ╲     Unit Tests (70%)
  ╱────────────╲
```

### 테스트 명령어

```bash
# 전체 테스트
npm test

# 단위 테스트만
npm run test:unit

# 통합 테스트만
npm run test:integration

# E2E 테스트
npm run test:e2e

# 커버리지 리포트
npm run test:coverage

# Watch 모드
npm run test:watch
```

### 테스트 파일 구조

```
src/
├── services/
│   ├── user-service.ts
│   └── __tests__/
│       ├── user-service.test.ts      # 단위 테스트
│       └── user-service.integration.test.ts  # 통합 테스트
tests/
└── e2e/
    └── user-flow.e2e.test.ts         # E2E 테스트
```

### 테스트 작성 가이드

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      // Arrange
      const userData = { email: 'test@example.com', name: 'Test' };

      // Act
      const user = await userService.createUser(userData);

      // Assert
      expect(user.email).toBe(userData.email);
    });

    it('should throw ValidationError for invalid email', async () => {
      // Arrange
      const invalidData = { email: 'invalid', name: 'Test' };

      // Act & Assert
      await expect(userService.createUser(invalidData))
        .rejects.toThrow(ValidationError);
    });
  });
});
```

## 디버깅

### 로깅

```typescript
import { logger } from '@/lib/logger';

// 레벨별 로깅
logger.debug('Debug message', { context: data });
logger.info('Info message');
logger.warn('Warning message');
logger.error('Error message', { error });
```

### VS Code 디버깅

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "console": "integratedTerminal"
    }
  ]
}
```

### 일반적인 디버깅 팁

1. `console.log`보다 logger 사용
2. 브레이크포인트 활용
3. 네트워크 요청은 개발자 도구에서 확인
4. 데이터베이스 쿼리는 쿼리 로그 활성화

## 성능 최적화

### 프로파일링

```bash
# Node.js 프로파일링
node --prof app.js

# 메모리 분석
node --inspect app.js
```

### 성능 체크리스트

- [ ] N+1 쿼리 문제 없음
- [ ] 적절한 인덱스 사용
- [ ] 불필요한 데이터 로딩 없음
- [ ] 캐싱 전략 적용
- [ ] 번들 크기 최적화

## 문서화

### 코드 문서화

```typescript
/**
 * Creates a new user account.
 *
 * @param data - User creation data
 * @returns Created user object
 * @throws {ValidationError} When email is invalid
 *
 * @example
 * const user = await createUser({
 *   email: 'user@example.com',
 *   name: 'John Doe'
 * });
 */
async function createUser(data: CreateUserDto): Promise<User> {
  // ...
}
```

### ADR 작성

중요한 아키텍처 결정은 [ADR](../adr/)로 문서화합니다.

## 배포

### 환경별 배포

| 환경 | 브랜치 | 자동 배포 |
|------|--------|----------|
| Development | develop | Yes |
| Staging | main | Yes |
| Production | main (tag) | Manual |

### 배포 프로세스

```
1. develop에서 개발
       ↓
2. main으로 PR & Merge
       ↓
3. Staging 자동 배포
       ↓
4. QA 테스트
       ↓
5. Release 태그 생성
       ↓
6. Production 배포 (승인 필요)
```

## 문제 해결

### 일반적인 문제

#### 빌드 실패

```bash
# 캐시 클리어
rm -rf node_modules .next dist
npm install
npm run build
```

#### 타입 에러

```bash
# 타입 재생성
npm run type-check
# 또는
npx tsc --noEmit
```

#### 테스트 실패

```bash
# 단일 테스트 실행
npm test -- --testPathPattern="user-service"

# 상세 로그
npm test -- --verbose
```

---

**참고 문서**:
- [시작 가이드](./getting-started.md)
- [API 문서](../api/)
- [아키텍처](../adr/)
