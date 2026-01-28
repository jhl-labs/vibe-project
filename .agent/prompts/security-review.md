# Security Review Prompt

## 목적
코드의 보안 취약점을 식별하고 개선 방안을 제시합니다.

## 컨텍스트
보안 검토 대상 코드와 시스템의 위협 모델을 이해해야 합니다.

---

## 프롬프트 템플릿

```
보안 검토를 해줘.

### 검토 대상
[파일 경로 또는 기능 설명]

### 시스템 컨텍스트
- [시스템 유형: 웹 앱/API/내부 도구 등]
- [인증 방식]
- [데이터 민감도]

### 주요 검토 영역
- [ ] 인증/인가
- [ ] 입력 유효성 검증
- [ ] 데이터 보호
- [ ] 세션 관리
- [ ] 에러 처리
- [ ] 로깅
- [ ] 암호화

### 위협 모델
[예상되는 공격자와 공격 벡터]

다음을 제공해줘:
1. 발견된 취약점 목록 (심각도별)
2. 각 취약점의 공격 시나리오
3. 수정 방안
4. 추가 권장 사항
```

---

## 출력 형식

```markdown
## 보안 검토 결과

### 요약
- 심각(Critical): N건
- 높음(High): N건
- 중간(Medium): N건
- 낮음(Low): N건

### 발견된 취약점

#### [CRITICAL] 취약점 제목
**위치:** `파일:라인`
**유형:** [OWASP 분류]
**설명:** [취약점 설명]

**공격 시나리오:**
\`\`\`
[공격 코드 또는 절차]
\`\`\`

**수정 방안:**
\`\`\`
[수정된 코드]
\`\`\`

### 추가 권장 사항
[보안 강화를 위한 추가 제안]
```

---

## 예시

### 입력
```
보안 검토를 해줘.

### 검토 대상
src/api/user.controller.ts - 사용자 정보 API

### 시스템 컨텍스트
- 시스템 유형: 공개 REST API
- 인증 방식: JWT
- 데이터 민감도: 개인정보 포함 (이메일, 전화번호)

### 주요 검토 영역
- [x] 인증/인가
- [x] 입력 유효성 검증
- [x] 데이터 보호

### 위협 모델
- 인증된 사용자가 타인의 정보에 접근 시도
- 악의적 입력으로 시스템 공격
```

### 출력
```markdown
## 보안 검토 결과

### 요약
- 심각(Critical): 1건
- 높음(High): 2건
- 중간(Medium): 1건
- 낮음(Low): 1건

### 발견된 취약점

#### [CRITICAL] IDOR - 타 사용자 정보 접근 가능
**위치:** `user.controller.ts:45`
**유형:** A01:2021-Broken Access Control
**설명:** getUserById 엔드포인트에서 요청자의 권한을 확인하지 않음

**현재 코드:**
\`\`\`typescript
@Get(':id')
async getUser(@Param('id') id: string) {
  return this.userService.findById(id); // 권한 확인 없음
}
\`\`\`

**공격 시나리오:**
\`\`\`bash
# 공격자가 타인의 사용자 ID를 추측하여 정보 탈취
curl -H "Authorization: Bearer <attacker_token>" \
     https://api.example.com/users/victim-user-id
\`\`\`

**수정 방안:**
\`\`\`typescript
@Get(':id')
@UseGuards(AuthGuard)
async getUser(
  @Param('id') id: string,
  @CurrentUser() currentUser: User
) {
  // 본인 또는 관리자만 접근 가능
  if (id !== currentUser.id && !currentUser.isAdmin) {
    throw new ForbiddenException();
  }
  return this.userService.findById(id);
}
\`\`\`

---

#### [HIGH] SQL Injection 가능성
**위치:** `user.service.ts:23`
**유형:** A03:2021-Injection
**설명:** 검색 쿼리에서 사용자 입력을 직접 문자열 연결

**현재 코드:**
\`\`\`typescript
async searchUsers(query: string) {
  return this.db.query(`SELECT * FROM users WHERE name LIKE '%${query}%'`);
}
\`\`\`

**공격 시나리오:**
\`\`\`
query = "'; DROP TABLE users; --"
\`\`\`

**수정 방안:**
\`\`\`typescript
async searchUsers(query: string) {
  return this.db.query(
    'SELECT * FROM users WHERE name LIKE $1',
    [`%${query}%`]
  );
}
\`\`\`

---

#### [HIGH] 민감 정보 로깅
**위치:** `user.controller.ts:12`
**유형:** A09:2021-Security Logging and Monitoring Failures
**설명:** 에러 로그에 전체 요청 본문(비밀번호 포함) 기록

**수정 방안:**
\`\`\`typescript
// 민감 필드 제거 후 로깅
const sanitizedBody = { ...body, password: '[REDACTED]' };
this.logger.error('Request failed', { body: sanitizedBody });
\`\`\`

---

#### [MEDIUM] Rate Limiting 미적용
**위치:** `user.controller.ts` 전체
**유형:** A04:2021-Insecure Design
**설명:** 로그인 시도 및 사용자 검색에 Rate Limiting 없음

**수정 방안:**
\`\`\`typescript
@UseGuards(ThrottlerGuard)
@Throttle(10, 60) // 60초당 10회 제한
@Post('login')
async login() { ... }
\`\`\`

---

#### [LOW] 응답에 불필요한 정보 포함
**위치:** `user.service.ts:15`
**설명:** 사용자 응답에 내부 ID, 생성일시 등 불필요 정보 포함

**수정 방안:**
응답 DTO를 정의하여 필요한 필드만 반환

### 추가 권장 사항

1. **보안 헤더 설정**
   - Helmet 미들웨어 적용
   - CORS 정책 강화

2. **입력 유효성 강화**
   - class-validator로 모든 입력 검증
   - 최대 길이 제한 적용

3. **감사 로깅**
   - 민감 작업(정보 조회, 수정)에 대한 감사 로그 추가

4. **의존성 보안**
   - `npm audit` 정기 실행
   - Dependabot 알림 활성화
```

---

## OWASP Top 10 체크리스트

- [ ] A01: Broken Access Control
- [ ] A02: Cryptographic Failures
- [ ] A03: Injection
- [ ] A04: Insecure Design
- [ ] A05: Security Misconfiguration
- [ ] A06: Vulnerable Components
- [ ] A07: Auth Failures
- [ ] A08: Software/Data Integrity
- [ ] A09: Logging Failures
- [ ] A10: SSRF
