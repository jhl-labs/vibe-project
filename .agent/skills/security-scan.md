# Security Scan Skill

> AI 에이전트의 보안 취약점 분석 가이드

## 트리거

```
/security
```

## 보안 스캔 범위

### OWASP Top 10 (2021)

| 순위 | 취약점 | 설명 |
|------|--------|------|
| A01 | Broken Access Control | 접근 제어 실패 |
| A02 | Cryptographic Failures | 암호화 실패 |
| A03 | Injection | 인젝션 공격 |
| A04 | Insecure Design | 안전하지 않은 설계 |
| A05 | Security Misconfiguration | 보안 설정 오류 |
| A06 | Vulnerable Components | 취약한 컴포넌트 |
| A07 | Authentication Failures | 인증 실패 |
| A08 | Data Integrity Failures | 데이터 무결성 실패 |
| A09 | Security Logging Failures | 보안 로깅 실패 |
| A10 | SSRF | 서버 사이드 요청 위조 |

## 취약점 탐지 패턴

### 1. SQL Injection (A03)

#### 취약한 코드 패턴

```typescript
// 위험: 문자열 결합
const query = `SELECT * FROM users WHERE id = ${userId}`;
const query = "SELECT * FROM users WHERE id = '" + userId + "'";

// 위험: 템플릿 리터럴
const query = `SELECT * FROM users WHERE name LIKE '%${searchTerm}%'`;
```

#### 안전한 코드 패턴

```typescript
// 안전: 파라미터화된 쿼리
const query = 'SELECT * FROM users WHERE id = $1';
const result = await db.query(query, [userId]);

// 안전: ORM 사용
const user = await User.findOne({ where: { id: userId } });

// 안전: Query Builder
const users = await db
  .select()
  .from('users')
  .where('name', 'like', `%${searchTerm}%`);
```

### 2. XSS (Cross-Site Scripting) (A03)

#### 취약한 코드 패턴

```typescript
// 위험: innerHTML 직접 삽입
element.innerHTML = userInput;

// 위험: document.write
document.write(userInput);

// 위험: React dangerouslySetInnerHTML
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// 위험: jQuery html()
$(element).html(userInput);
```

#### 안전한 코드 패턴

```typescript
// 안전: textContent 사용
element.textContent = userInput;

// 안전: 이스케이프 처리
element.innerHTML = DOMPurify.sanitize(userInput);

// 안전: React 기본 동작 (자동 이스케이프)
<div>{userInput}</div>
```

### 3. 인증/세션 관리 (A07)

#### 취약한 코드 패턴

```typescript
// 위험: 평문 비밀번호 저장
await db.query('INSERT INTO users (password) VALUES ($1)', [password]);

// 위험: 약한 해시 알고리즘
const hash = md5(password);
const hash = sha1(password);

// 위험: JWT를 localStorage에 저장
localStorage.setItem('token', jwtToken);

// 위험: 세션 ID 노출
res.redirect(`/dashboard?sessionId=${sessionId}`);
```

#### 안전한 코드 패턴

```typescript
// 안전: bcrypt 또는 argon2 사용
const hash = await bcrypt.hash(password, 12);
const hash = await argon2.hash(password);

// 안전: httpOnly 쿠키
res.cookie('token', jwtToken, {
  httpOnly: true,
  secure: true,
  sameSite: 'strict',
  maxAge: 3600000
});

// 안전: 세션 ID는 쿠키로만
// URL이나 응답 본문에 포함하지 않음
```

### 4. 접근 제어 (A01)

#### 취약한 코드 패턴

```typescript
// 위험: 인가 검사 누락
app.get('/admin/users', (req, res) => {
  // 권한 검사 없이 직접 접근
  return getAllUsers();
});

// 위험: 클라이언트 측 권한 검사만
if (user.role === 'admin') {
  showAdminPanel();
}

// 위험: ID 기반 직접 접근 (IDOR)
app.get('/api/orders/:id', async (req, res) => {
  const order = await Order.findById(req.params.id);
  return res.json(order);
});
```

#### 안전한 코드 패턴

```typescript
// 안전: 미들웨어로 권한 검사
app.get('/admin/users',
  authenticate,
  authorize('admin'),
  (req, res) => getAllUsers()
);

// 안전: 서버 측 권한 검사
app.get('/api/orders/:id', authenticate, async (req, res) => {
  const order = await Order.findOne({
    _id: req.params.id,
    userId: req.user.id  // 소유권 확인
  });
  if (!order) return res.status(404).json({ error: 'Not found' });
  return res.json(order);
});
```

### 5. 민감 정보 노출 (A02)

#### 취약한 코드 패턴

```typescript
// 위험: 하드코딩된 시크릿
const API_KEY = 'sk-1234567890abcdef';
const DB_PASSWORD = 'super_secret_password';

// 위험: 에러 메시지에 상세 정보
catch (error) {
  res.status(500).json({
    error: error.message,
    stack: error.stack  // 스택 트레이스 노출
  });
}

// 위험: 로그에 민감 정보
console.log('User login:', { email, password });
logger.info('Payment processed', { creditCard });
```

#### 안전한 코드 패턴

```typescript
// 안전: 환경 변수 사용
const API_KEY = process.env.API_KEY;
const DB_PASSWORD = process.env.DB_PASSWORD;

// 안전: 일반적인 에러 메시지
catch (error) {
  logger.error('Internal error', { error });  // 서버 로그에만
  res.status(500).json({
    error: 'Internal server error',
    requestId: req.id  // 추적용 ID만
  });
}

// 안전: 민감 정보 마스킹
logger.info('User login:', { email, password: '[REDACTED]' });
logger.info('Payment processed', {
  creditCard: maskCreditCard(creditCard)
});
```

### 6. SSRF (A10)

#### 취약한 코드 패턴

```typescript
// 위험: 사용자 입력 URL 직접 요청
app.get('/fetch', async (req, res) => {
  const response = await fetch(req.query.url);
  return res.json(await response.json());
});

// 위험: 내부 서비스 접근 가능
const data = await axios.get(userProvidedUrl);
```

#### 안전한 코드 패턴

```typescript
// 안전: URL allowlist
const ALLOWED_DOMAINS = ['api.example.com', 'cdn.example.com'];

app.get('/fetch', async (req, res) => {
  const url = new URL(req.query.url);

  if (!ALLOWED_DOMAINS.includes(url.hostname)) {
    return res.status(400).json({ error: 'Domain not allowed' });
  }

  // 내부 IP 차단
  if (isPrivateIP(url.hostname)) {
    return res.status(400).json({ error: 'Private IP not allowed' });
  }

  const response = await fetch(url.toString());
  return res.json(await response.json());
});
```

## 보안 스캔 프로세스

### Step 1: 정적 분석

```markdown
1. 코드 패턴 검사
2. 하드코딩된 시크릿 탐지
3. 취약한 함수 사용 탐지
4. 의존성 취약점 확인
```

### Step 2: 데이터 흐름 분석

```markdown
1. 사용자 입력 추적
2. 신뢰 경계 식별
3. 데이터 검증 지점 확인
4. 출력 이스케이프 확인
```

### Step 3: 설정 검토

```markdown
1. 보안 헤더 확인
2. CORS 설정 검토
3. 인증/세션 설정 검토
4. 암호화 설정 확인
```

## AI 보안 스캔 출력 형식

```markdown
## 보안 스캔 결과

### 요약
- **스캔 범위**: src/ 디렉토리
- **파일 수**: 45개
- **발견된 취약점**: 7개
  - 🔴 Critical: 1개
  - 🟠 High: 2개
  - 🟡 Medium: 3개
  - 🟢 Low: 1개

---

### 🔴 Critical: SQL Injection

**위치**: `src/api/users.ts:45`

**취약 코드**:
```typescript
const query = `SELECT * FROM users WHERE id = ${req.params.id}`;
```

**공격 시나리오**:
```
GET /api/users/1' OR '1'='1
→ 모든 사용자 데이터 유출
```

**수정 권고**:
```typescript
const query = 'SELECT * FROM users WHERE id = $1';
const result = await db.query(query, [req.params.id]);
```

**참고**: [CWE-89](https://cwe.mitre.org/data/definitions/89.html)

---

### 🟠 High: Missing Authentication

**위치**: `src/api/admin.ts:12`

**문제**: `/admin/users` 엔드포인트에 인증 미들웨어 누락

**수정 권고**:
```typescript
router.get('/admin/users', authenticate, authorize('admin'), handler);
```

---

### 권장 조치

#### 즉시 조치 (24시간 내)
1. SQL Injection 취약점 수정
2. 관리자 API 인증 추가

#### 단기 조치 (1주일 내)
1. XSS 취약점 수정
2. 보안 헤더 추가

#### 중기 조치 (1개월 내)
1. 의존성 업데이트
2. 보안 로깅 강화
```

## 보안 체크리스트

### 입력 검증

- [ ] 모든 사용자 입력이 서버 측에서 검증되는가?
- [ ] 파일 업로드 시 타입/크기 검증이 있는가?
- [ ] URL 파라미터와 쿼리스트링이 검증되는가?

### 인증/인가

- [ ] 비밀번호가 안전하게 해싱되는가? (bcrypt/argon2)
- [ ] 세션 토큰이 안전하게 관리되는가?
- [ ] 모든 보호된 리소스에 인가 검사가 있는가?

### 데이터 보호

- [ ] 민감 데이터가 암호화되는가?
- [ ] HTTPS가 강제되는가?
- [ ] 민감 정보가 로그에 노출되지 않는가?

### 보안 헤더

- [ ] Content-Security-Policy 설정?
- [ ] X-Content-Type-Options: nosniff?
- [ ] X-Frame-Options: DENY?
- [ ] Strict-Transport-Security?

## 참고 자료

- [OWASP Top 10](https://owasp.org/Top10/)
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
- [CWE Database](https://cwe.mitre.org/)
- [Security Subagent](../subagents/security.md)

---

**Note**: 보안 취약점 발견 시 즉시 팀에 보고하고, 프로덕션 배포 전 반드시 수정하세요.
