# Code Review Prompt

## 목적
코드 변경사항을 체계적으로 리뷰합니다.

## 컨텍스트
PR 또는 코드 변경의 목적과 범위를 이해한 상태에서 리뷰합니다.

---

## 프롬프트 템플릿

```
다음 코드를 리뷰해줘.

### 변경 목적
[이 코드 변경의 목적]

### 변경된 파일
- [파일 1]
- [파일 2]

### 리뷰 중점 사항
- [ ] 로직 정확성
- [ ] 에러 처리
- [ ] 성능
- [ ] 보안
- [ ] 테스트 커버리지
- [ ] 코드 스타일

### 특별히 확인해야 할 부분
[특정 우려 사항이나 집중 검토 영역]
```

---

## 출력 형식

```markdown
## 코드 리뷰 결과

### 요약
[전체적인 코드 품질 평가]

### 승인 상태
🟢 승인 / 🟡 수정 후 승인 / 🔴 변경 요청

### 상세 피드백

#### Critical (반드시 수정)
- `파일:라인` - [문제점 및 수정 제안]

#### Major (수정 권장)
- `파일:라인` - [문제점 및 수정 제안]

#### Minor (선택적 수정)
- `파일:라인` - [개선 제안]

#### Positive (잘한 점)
- [칭찬할 만한 부분]

### 질문/논의사항
- [이해가 필요한 부분이나 설계 결정에 대한 질문]
```

---

## 예시

### 입력
```
다음 코드를 리뷰해줘.

### 변경 목적
사용자 프로필 이미지 업로드 기능 추가

### 변경된 파일
- src/controllers/user.controller.ts
- src/services/upload.service.ts
- src/routes/user.routes.ts

### 리뷰 중점 사항
- [x] 로직 정확성
- [x] 에러 처리
- [x] 보안 (파일 업로드)

### 특별히 확인해야 할 부분
파일 타입 검증과 크기 제한이 제대로 되어 있는지
```

### 출력
```markdown
## 코드 리뷰 결과

### 요약
전반적으로 기능 구현은 완료되었으나,
보안 관련 몇 가지 중요한 수정이 필요합니다.

### 승인 상태
🟡 수정 후 승인

### 상세 피드백

#### Critical (반드시 수정)

1. `upload.service.ts:45` - 파일 확장자만 검증하고 MIME 타입을 검증하지 않음
   ```typescript
   // 현재 코드
   if (!['jpg', 'png'].includes(ext)) throw new Error();

   // 제안
   const allowedMimes = ['image/jpeg', 'image/png'];
   if (!allowedMimes.includes(file.mimetype)) throw new Error();
   ```

2. `upload.service.ts:52` - 파일명에 path traversal 취약점 존재
   ```typescript
   // 현재 코드
   const filepath = `uploads/${filename}`;

   // 제안
   const safeFilename = path.basename(filename);
   const filepath = path.join('uploads', safeFilename);
   ```

#### Major (수정 권장)

1. `user.controller.ts:78` - 에러 시 임시 파일 정리 누락
   ```typescript
   // try-catch-finally로 임시 파일 삭제 보장
   ```

#### Minor (선택적 수정)

1. `user.routes.ts:12` - 업로드 크기 제한이 라우트에 직접 하드코딩됨
   - 설정 파일로 분리 권장

#### Positive (잘한 점)
- 업로드 진행률 콜백 구현이 깔끔함
- 이미지 리사이징 로직이 별도 서비스로 잘 분리됨

### 질문/논의사항
- 업로드된 파일의 CDN 연동 계획이 있나요?
- 기존 프로필 이미지 삭제 정책은?
```

---

## 리뷰 기준

### 로직 정확성
- 요구사항 충족 여부
- 엣지 케이스 처리
- null/undefined 처리

### 에러 처리
- 적절한 에러 타입 사용
- 사용자 친화적 메시지
- 로깅 적절성

### 성능
- N+1 쿼리 문제
- 불필요한 연산
- 메모리 누수 가능성

### 보안
- 입력값 검증
- 인증/권한 확인
- 민감 정보 노출

### 테스트
- 테스트 커버리지
- 엣지 케이스 테스트
- 모킹 적절성

### 코드 스타일
- 명명 규칙
- 코드 구조
- 주석 적절성
