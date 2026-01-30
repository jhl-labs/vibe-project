# Slash Commands 가이드

> AI 에이전트에서 사용할 수 있는 빠른 명령어

## 개요

Slash Commands는 AI 에이전트에게 특정 작업을 빠르게 요청하는 단축 명령어입니다. 이 명령어들은 일관된 출력 형식과 품질을 보장합니다.

## 명령어 목록

| 명령어 | 설명 | 결과물 |
|--------|------|--------|
| `/commit` | 커밋 메시지 생성 | Conventional Commit 형식 메시지 |
| `/pr` | PR 설명 생성 | PR 제목, 설명, 체크리스트 |
| `/review` | 코드 리뷰 | 리뷰 코멘트 및 제안 |
| `/test` | 테스트 케이스 생성 | 단위 테스트 코드 |
| `/doc` | 문서 생성 | API 문서, JSDoc 등 |
| `/refactor` | 리팩토링 제안 | 개선된 코드 및 설명 |
| `/security` | 보안 스캔 | 취약점 리포트 |
| `/changelog` | 변경 이력 업데이트 | CHANGELOG 엔트리 |
| `/migrate` | 마이그레이션 스크립트 | DB/스키마 마이그레이션 |
| `/hotfix` | 긴급 패치 가이드 | 핫픽스 워크플로우 |

---

## 상세 명령어

### `/commit` - 커밋 메시지 생성

스테이징된 변경사항을 분석하여 Conventional Commits 형식의 커밋 메시지를 생성합니다.

**사용법:**
```
/commit
```

**출력 형식:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**예시:**
```
feat(auth): add JWT refresh token support

- Implement refresh token rotation
- Add token blacklist for logout
- Update auth middleware to handle refresh

Closes #123
```

**타입 선택 기준:**
| 타입 | 사용 시점 |
|------|----------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `docs` | 문서만 변경 |
| `style` | 코드 포맷팅 (기능 변화 없음) |
| `refactor` | 기능 변화 없는 코드 개선 |
| `test` | 테스트 추가/수정 |
| `chore` | 빌드/설정 변경 |
| `perf` | 성능 개선 |
| `security` | 보안 관련 변경 |

---

### `/pr` - PR 설명 생성

브랜치의 변경사항을 분석하여 PR 제목과 설명을 생성합니다.

**사용법:**
```
/pr
/pr --base main
/pr --template detailed
```

**출력 형식:**
```markdown
## PR 제목
[type]: 간결한 설명

## 요약
변경사항 요약 (2-3문장)

## 변경 상세
### 추가된 것
- 항목 1
- 항목 2

### 변경된 것
- 항목 1

### 제거된 것
- 항목 1

## 관련 이슈
Closes #123

## 테스트
- [ ] 단위 테스트 추가
- [ ] 통합 테스트 확인
- [ ] 수동 테스트 완료

## 체크리스트
- [ ] 자체 코드 리뷰 완료
- [ ] 문서 업데이트
- [ ] 린트 통과
```

---

### `/review` - 코드 리뷰

지정된 코드 또는 현재 변경사항에 대한 코드 리뷰를 수행합니다.

**사용법:**
```
/review
/review src/services/user.ts
/review --focus security
```

**출력 형식:**
```markdown
## 코드 리뷰 결과

### 요약
- 변경 파일: N개
- 발견된 이슈: N개

### 필수 수정 (Blocker)
🚨 **[파일:라인]** 설명
```suggestion
수정 제안 코드
```

### 권장 사항 (Suggestion)
💡 **[파일:라인]** 설명

### 질문 (Question)
❓ **[파일:라인]** 질문 내용

### 좋은 점 (Praise)
✨ 칭찬할 부분

### 결론
[승인 / 수정 요청 / 코멘트]
```

---

### `/test` - 테스트 케이스 생성

지정된 코드에 대한 테스트 케이스를 생성합니다.

**사용법:**
```
/test src/services/user.ts
/test --type unit
/test --type integration
/test --coverage 80
```

**출력 형식:**
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      // Arrange
      // Act
      // Assert
    });

    it('should throw ValidationError for invalid email', async () => {
      // ...
    });
  });
});
```

---

### `/doc` - 문서 생성

코드에 대한 문서를 생성합니다.

**사용법:**
```
/doc src/services/user.ts
/doc --type jsdoc
/doc --type api
/doc --type readme
```

**출력 형식 (JSDoc):**
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
 *   name: 'John'
 * });
 */
```

---

### `/refactor` - 리팩토링 제안

코드 개선을 위한 리팩토링을 제안합니다.

**사용법:**
```
/refactor src/services/order.ts
/refactor --focus performance
/refactor --focus readability
```

**출력 형식:**
```markdown
## 리팩토링 제안

### 대상
- 파일: `src/services/order.ts`
- 함수: `processOrder`

### 발견된 코드 스멜
1. Long Method (75줄)
2. Complex Conditional (5단계 중첩)

### 제안

#### Step 1: Extract Function
```typescript
// Before
[기존 코드]

// After
[개선된 코드]
```

### 예상 효과
- 가독성 향상
- 테스트 용이성 개선
```

---

### `/security` - 보안 스캔

코드의 보안 취약점을 분석합니다.

**사용법:**
```
/security
/security src/api/
/security --severity high
```

**출력 형식:**
```markdown
## 보안 스캔 결과

### 요약
- 스캔 범위: src/
- 발견된 취약점: N개
  - 🔴 Critical: N개
  - 🟠 High: N개
  - 🟡 Medium: N개

### 상세

#### 🔴 SQL Injection
- **위치**: `src/api/users.ts:45`
- **설명**: 사용자 입력이 쿼리에 직접 사용됨
- **수정 권고**: 파라미터화된 쿼리 사용

### 권장 조치
1. Critical/High 즉시 수정
2. Medium 1주일 내 수정
```

---

### `/changelog` - 변경 이력 업데이트

최근 변경사항을 CHANGELOG에 추가할 엔트리를 생성합니다.

**사용법:**
```
/changelog
/changelog --version 1.2.0
/changelog --since v1.1.0
```

**출력 형식:**
```markdown
## [1.2.0] - 2024-01-15

### Added
- JWT 리프레시 토큰 지원 (#123)
- 사용자 프로필 API (#124)

### Changed
- 로그인 플로우 개선 (#125)

### Fixed
- 세션 만료 버그 수정 (#126)

### Security
- XSS 취약점 패치 (#127)
```

---

### `/migrate` - 마이그레이션 스크립트

데이터베이스 또는 스키마 마이그레이션 스크립트를 생성합니다.

**사용법:**
```
/migrate add-user-role-column
/migrate --type sql
/migrate --type prisma
```

**출력 형식 (SQL):**
```sql
-- Migration: add_user_role_column
-- Created at: 2024-01-15

-- Up
ALTER TABLE users ADD COLUMN role VARCHAR(50) DEFAULT 'user';
CREATE INDEX idx_users_role ON users(role);

-- Down
DROP INDEX idx_users_role;
ALTER TABLE users DROP COLUMN role;
```

---

### `/hotfix` - 긴급 패치 가이드

긴급 수정이 필요한 상황에서의 워크플로우를 안내합니다.

**사용법:**
```
/hotfix
/hotfix --issue 123
```

**출력 형식:**
```markdown
## 핫픽스 워크플로우

### 1. 브랜치 생성
```bash
git checkout main
git pull origin main
git checkout -b hotfix/ISSUE-123-critical-bug
```

### 2. 수정 및 테스트
- [ ] 버그 수정
- [ ] 단위 테스트 추가
- [ ] 로컬 테스트

### 3. 배포
```bash
git add .
git commit -m "fix: critical bug description"
git push origin hotfix/ISSUE-123-critical-bug
```

### 4. PR 생성
- base: `main`
- 리뷰어: @security-team
- 라벨: `hotfix`, `urgent`

### 5. 배포 후
- [ ] 프로덕션 모니터링
- [ ] 근본 원인 분석
- [ ] develop 브랜치에 백포트
```

---

## 명령어 조합

여러 명령어를 순차적으로 사용할 수 있습니다:

```
/review → /test → /commit → /pr
```

## 커스터마이징

프로젝트별로 명령어 동작을 커스터마이징하려면:

1. `.agent/skills/` 디렉토리의 해당 스킬 파일 수정
2. 팀별 요구사항에 맞게 출력 형식 조정
3. 추가 검사 항목이나 템플릿 추가

## 관련 프롬프트 라이브러리

이 명령어들과 대응하는 상세 프롬프트 템플릿:

| 명령어 | 프롬프트 파일 |
|--------|-------------|
| `/review` | [code-review.md](./prompts/code-review.md) |
| `/test` | [test-generation.md](./prompts/test-generation.md) |
| `/doc` | [api-docs.md](./prompts/api-docs.md), [readme-gen.md](./prompts/readme-gen.md) |
| `/refactor` | [refactor.md](./prompts/refactor.md) |
| `/security` | [security-review.md](./prompts/security-review.md) |
| `/migrate` | [migration.md](./prompts/migration.md) |

## 관련 스킬

- [Code Review Skill](./skills/code-review.md)
- [Test Generation Skill](./skills/test-gen.md)
- [Documentation Skill](./skills/doc-gen.md)
- [Refactor Skill](./skills/refactor.md)
- [Security Scan Skill](./skills/security-scan.md)

---

**Note**: 명령어의 구체적인 동작은 사용하는 AI 에이전트에 따라 다를 수 있습니다.
