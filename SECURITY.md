# Security Policy

> 보안 정책 및 취약점 보고 가이드

## 지원 버전

현재 보안 업데이트를 받는 버전입니다:

| 버전 | 지원 상태 |
|------|----------|
| 1.x.x | :white_check_mark: 지원 |
| < 1.0 | :x: 미지원 |

## 취약점 보고

보안 취약점을 발견하셨나요? **공개 이슈로 보고하지 마세요.**

### 보고 방법

1. **GitHub Security Advisory** (권장)
   - [Security Advisories](https://github.com/<your-org>/<your-project>/security/advisories/new)에서 비공개 보고서를 작성하세요

2. **이메일**
   - 보안 이메일: `security@<your-domain>.com`
   - 제목: `[SECURITY] <간단한 설명>`

### 보고서 내용

다음 정보를 포함해주세요:

- **취약점 유형**: (예: XSS, SQL Injection, CSRF 등)
- **영향받는 컴포넌트**: (파일 경로, 엔드포인트 등)
- **재현 방법**: 단계별 설명
- **영향도 평가**: 예상되는 피해 범위
- **권장 수정 방안**: (있다면)

### 예시 보고서

```markdown
## 취약점 요약
사용자 입력이 검증 없이 SQL 쿼리에 사용되어 SQL Injection 가능

## 영향받는 컴포넌트
- 파일: `src/api/users.ts`
- 엔드포인트: `GET /api/users?search=`

## 재현 방법
1. `/api/users?search=' OR '1'='1` 요청
2. 모든 사용자 데이터가 반환됨

## 영향도
- 심각도: High
- 영향: 데이터 유출, 데이터 조작 가능

## 권장 수정
파라미터화된 쿼리 사용
```

## 보안 업데이트

### 알림 받기

- GitHub의 "Watch" 기능에서 "Security alerts" 활성화
- [릴리스 노트](https://github.com/<your-org>/<your-project>/releases) 확인

### 업데이트 적용

```bash
# Node.js
npm outdated && npm audit fix && npm update

# Python
pip list --outdated && pip install --upgrade -r requirements.txt

# Go
go list -u -m all && go get -u ./...
```

## 보안 모범 사례

### 개발자를 위한 가이드

#### 입력 검증

```typescript
// Good: 입력 검증
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
});

// Bad: 검증 없이 사용
const { email, name } = req.body;
```

#### SQL 인젝션 방지

```typescript
// Good: 파라미터화된 쿼리
const user = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);

// Bad: 문자열 결합
const user = await db.query(
  `SELECT * FROM users WHERE id = ${userId}`
);
```

#### XSS 방지

```typescript
// Good: 이스케이프 처리
import { escapeHtml } from '@/utils/security';
element.textContent = userInput;

// Bad: innerHTML에 직접 삽입
element.innerHTML = userInput;
```

#### 인증/인가

```typescript
// Good: 모든 엔드포인트에 인증 확인
router.get('/api/users/:id', authenticate, authorize('admin'), getUser);

// Bad: 인증 없이 노출
router.get('/api/users/:id', getUser);
```

#### 비밀 관리

```typescript
// Good: 환경 변수 사용
const apiKey = process.env.API_KEY;

// Bad: 코드에 하드코딩
const apiKey = 'sk-1234567890abcdef';
```

### 체크리스트

#### 코드 리뷰 시

- [ ] 입력이 적절히 검증되는가?
- [ ] SQL/NoSQL 쿼리가 파라미터화되었는가?
- [ ] 사용자 출력이 이스케이프되었는가?
- [ ] 인증/인가가 적용되었는가?
- [ ] 민감 정보가 로그에 노출되지 않는가?
- [ ] 에러 메시지가 내부 정보를 노출하지 않는가?

#### 배포 전

- [ ] 의존성 취약점 확인 (`npm audit` / `pip audit` / `go vuln`)
- [ ] 최신 보안 패치 적용
- [ ] 환경 변수 설정 확인
- [ ] HTTPS 강제 설정
- [ ] 보안 헤더 설정 (CSP, HSTS 등)

## 보안 도구

### 의존성 검사

```bash
# Node.js
npm audit
npx snyk test

# Python
pip audit
safety check -r requirements.txt

# Go
govulncheck ./...
```

### 정적 분석

```bash
# Linter (프로젝트에 맞게 선택)
npm run lint       # Node.js (ESLint)
ruff check .       # Python

# Semgrep (범용)
semgrep --config=auto .
```

### 시크릿 스캔

```bash
# Gitleaks
gitleaks detect --source .

# TruffleHog
trufflehog git file://. --only-verified
```

## 대응 절차

### 취약점 발견 시

1. **확인**: 취약점 재현 및 영향 범위 파악
2. **격리**: 필요시 영향받는 기능 비활성화
3. **수정**: 보안 패치 개발
4. **테스트**: 수정 검증
5. **배포**: 패치 릴리스
6. **알림**: 사용자에게 업데이트 권고
7. **문서화**: 보안 권고문 발행

### 타임라인

| 단계 | 목표 시간 |
|------|----------|
| 초기 응답 | 24시간 이내 |
| 확인 완료 | 48시간 이내 |
| 패치 릴리스 | 심각도에 따라 |

**심각도별 대응 시간:**

- Critical: 24-48시간
- High: 1주일
- Medium: 2주일
- Low: 다음 정기 릴리스

## 면책 조항

선의의 보안 연구를 장려합니다. 책임감 있게 취약점을 보고해주시면:

- 법적 조치를 취하지 않습니다
- 연구자의 노력을 인정합니다 (원하는 경우)
- 보안 권고문에 크레딧을 포함합니다

## 연락처

- 보안 이메일: `security@<your-domain>.com`
- GitHub Security Advisories: [링크](https://github.com/<your-org>/<your-project>/security/advisories)

---

**Note**: 이 정책은 정기적으로 검토 및 업데이트됩니다.
마지막 업데이트: `<날짜>`
