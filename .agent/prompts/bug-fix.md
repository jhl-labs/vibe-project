# Bug Fix Prompt

## 목적
버그를 체계적으로 분석하고 수정합니다.

## 컨텍스트
버그의 증상, 재현 방법, 관련 코드에 대한 정보가 필요합니다.

---

## 프롬프트 템플릿

```
버그를 수정해야 해.

### 증상
[버그 발생 시 나타나는 현상]

### 재현 방법
1. [단계 1]
2. [단계 2]
3. [버그 발생]

### 예상 동작
[정상적으로 동작해야 하는 방식]

### 실제 동작
[현재 잘못된 동작]

### 관련 코드 위치
- [파일 경로 1]
- [파일 경로 2]

### 에러 메시지 (있는 경우)
\`\`\`
[에러 로그 또는 스택 트레이스]
\`\`\`

다음 순서로 진행해줘:
1. 근본 원인 분석
2. 수정 방안 제시
3. 코드 수정
4. 테스트 코드 작성
```

---

## 출력 형식

```markdown
## 버그 분석 및 수정

### 근본 원인
[왜 이 버그가 발생하는지 설명]

### 수정 방안
[어떻게 수정할 것인지 설명]

### 변경 사항
1. `파일명`: [변경 내용]
2. `파일명`: [변경 내용]

### 수정 코드
[코드 블록]

### 테스트
[테스트 코드 또는 검증 방법]

### 회귀 방지
[이 버그가 재발하지 않도록 하는 방안]
```

---

## 예시

### 입력
```
버그를 수정해야 해.

### 증상
사용자 로그인 시 간헐적으로 "Invalid token" 에러 발생

### 재현 방법
1. 로그인 페이지에서 정상 로그인
2. 5분 정도 대기
3. 페이지 새로고침
4. 간헐적으로 로그인 풀림

### 예상 동작
토큰 유효 시간(1시간) 내에는 로그인 유지

### 실제 동작
5-10분 후 간헐적으로 로그인 풀림

### 관련 코드 위치
- src/services/auth.ts
- src/middleware/auth.middleware.ts

### 에러 메시지
\`\`\`
Error: Invalid token
    at verifyToken (auth.middleware.ts:25)
    at processTicksAndRejections
\`\`\`
```

### 출력
```markdown
## 버그 분석 및 수정

### 근본 원인
토큰 검증 시 서버 시간과 토큰 생성 시간 사이에 시간대(timezone) 불일치가 있습니다.
서버가 UTC를 사용하지만 토큰 생성 시 로컬 시간을 사용하고 있어,
특정 조건에서 토큰이 미래에 생성된 것으로 판단되어 무효화됩니다.

### 수정 방안
1. 토큰 생성 시 UTC 시간 사용 강제
2. 토큰 검증 시 시간대 고려 로직 추가

### 변경 사항
1. `src/services/auth.ts`: 토큰 생성 시 UTC 사용
2. `src/middleware/auth.middleware.ts`: 검증 로직에 clock skew 허용

### 수정 코드
\`\`\`typescript
// auth.ts
const generateToken = (userId: string) => {
  return jwt.sign(
    { userId, iat: Math.floor(Date.now() / 1000) }, // UTC timestamp
    SECRET,
    { expiresIn: '1h' }
  );
};

// auth.middleware.ts
const verifyToken = (token: string) => {
  return jwt.verify(token, SECRET, {
    clockTolerance: 60 // 60초 허용
  });
};
\`\`\`

### 테스트
\`\`\`typescript
describe('Token verification', () => {
  it('should accept token with minor time difference', () => {
    // 시간 조작하여 테스트
  });
});
\`\`\`

### 회귀 방지
- CI에 시간대 관련 테스트 추가
- 토큰 생성/검증 로직을 단일 모듈로 캡슐화
```

---

## 체크리스트

수정 완료 후 확인:
- [ ] 근본 원인 파악 완료
- [ ] 재현 테스트 작성
- [ ] 수정 후 버그 해소 확인
- [ ] 사이드 이펙트 검토
- [ ] 회귀 테스트 추가
- [ ] 관련 문서 업데이트
