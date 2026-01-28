# Dependency Upgrade Prompt

## 목적
라이브러리/프레임워크의 버전을 안전하게 업그레이드합니다.

## 컨텍스트
업그레이드 대상과 현재 사용 방식을 파악해야 합니다.

---

## 프롬프트 템플릿

```
의존성 업그레이드를 도와줘.

### 업그레이드 대상
- 라이브러리명: [이름]
- 현재 버전: [버전]
- 목표 버전: [버전]

### 업그레이드 이유
[보안 취약점 / 새 기능 필요 / EOL 등]

### 현재 사용 방식
[라이브러리를 어떻게 사용하고 있는지]

### 관련 파일
- [사용하는 주요 파일들]

### 제약 조건
- [호환성 요구사항]
- [다운타임 허용 여부]

다음을 제공해줘:
1. Breaking changes 목록
2. 마이그레이션 단계
3. 코드 변경 사항
4. 테스트 계획
```

---

## 출력 형식

```markdown
## 의존성 업그레이드 가이드

### 변경 사항 분석

#### Breaking Changes
| 변경 | 영향 | 대응 |
|------|------|------|
| ... | ... | ... |

#### 새로운 기능
- [선택적 적용 가능한 새 기능]

#### 사용 중단(Deprecated)
- [deprecated된 API와 대체 방안]

### 마이그레이션 단계

1. [단계 1]
2. [단계 2]
...

### 코드 변경 사항

#### 파일: [경로]
\`\`\`
[변경 코드]
\`\`\`

### 테스트 계획
- [ ] 단위 테스트
- [ ] 통합 테스트
- [ ] 회귀 테스트
```

---

## 예시

### 입력
```
의존성 업그레이드를 도와줘.

### 업그레이드 대상
- 라이브러리명: React
- 현재 버전: 17.0.2
- 목표 버전: 18.2.0

### 업그레이드 이유
- Concurrent 기능 필요
- 성능 개선
- 커뮤니티 지원

### 현재 사용 방식
- CRA로 생성된 프로젝트
- Redux, React Router 사용
- 클래스 컴포넌트 일부 존재

### 관련 파일
- src/index.tsx
- src/App.tsx
- src/components/*

### 제약 조건
- 점진적 마이그레이션 선호
- 프로덕션 중단 불가
```

### 출력
```markdown
## React 17 → 18 업그레이드 가이드

### 변경 사항 분석

#### Breaking Changes
| 변경 | 영향 | 대응 |
|------|------|------|
| ReactDOM.render 제거 | index.tsx | createRoot 사용 |
| 자동 배칭 | 상태 업데이트 동작 변경 | 대부분 호환, 일부 테스트 수정 |
| Strict Mode 이중 실행 | useEffect 두 번 실행 | 이미 적용된 경우 영향 없음 |
| TypeScript 타입 변경 | children prop | 명시적 선언 필요 |

#### 새로운 기능 (선택적 적용)
- `useTransition` - 낮은 우선순위 업데이트
- `useDeferredValue` - 값의 지연 업데이트
- `Suspense` SSR 지원
- `useId` - 고유 ID 생성

#### 사용 중단(Deprecated)
- `ReactDOM.render` → `createRoot`
- `ReactDOM.hydrate` → `hydrateRoot`
- `ReactDOM.unmountComponentAtNode` → `root.unmount()`

### 호환성 확인

#### 관련 라이브러리
| 라이브러리 | 현재 버전 | 필요 버전 | 상태 |
|------------|-----------|-----------|------|
| react-dom | 17.0.2 | 18.2.0 | 업그레이드 필요 |
| react-redux | 7.x | 8.x 권장 | 7.x도 호환 |
| react-router | 5.x | 6.x 권장 | 5.x도 호환 |
| @types/react | 17.x | 18.x | 업그레이드 필요 |

### 마이그레이션 단계

#### Step 1: 의존성 업그레이드

\`\`\`bash
npm install react@18.2.0 react-dom@18.2.0
npm install -D @types/react@18 @types/react-dom@18
\`\`\`

#### Step 2: 엔트리 포인트 수정

**변경 전:** `src/index.tsx`
\`\`\`tsx
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
\`\`\`

**변경 후:**
\`\`\`tsx
import { createRoot } from 'react-dom/client';
import App from './App';

const container = document.getElementById('root')!;
const root = createRoot(container);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
\`\`\`

#### Step 3: TypeScript children prop 수정

React 18에서는 `FC`에 암시적 `children`이 없습니다.

**변경 전:**
\`\`\`tsx
const Layout: React.FC = ({ children }) => {
  return <div>{children}</div>;
};
\`\`\`

**변경 후:**
\`\`\`tsx
import { PropsWithChildren } from 'react';

const Layout = ({ children }: PropsWithChildren) => {
  return <div>{children}</div>;
};
\`\`\`

#### Step 4: 테스트 업데이트

React Testing Library의 `render`가 자동으로 `createRoot`를 사용하므로
대부분 테스트는 수정 없이 동작합니다.

**act 경고 해결:**
\`\`\`tsx
import { act } from 'react-dom/test-utils';

await act(async () => {
  // 비동기 작업
});
\`\`\`

### 점진적 마이그레이션 전략

1. **1단계**: 의존성 + 엔트리 포인트 (필수)
2. **2단계**: TypeScript 타입 오류 수정
3. **3단계**: 테스트 수정 및 실행
4. **4단계**: (선택) 새 기능 점진 적용

### 테스트 계획

#### 자동 테스트
- [ ] 기존 단위 테스트 전체 실행
- [ ] E2E 테스트 실행
- [ ] 타입 체크 (`tsc --noEmit`)

#### 수동 테스트
- [ ] 주요 사용자 플로우 검증
- [ ] 폼 제출 동작 확인
- [ ] 비동기 데이터 로딩 확인
- [ ] 에러 바운더리 동작 확인

### 롤백 계획

문제 발생 시:
\`\`\`bash
git revert <commit-hash>
npm install  # package-lock.json 복원
\`\`\`
```

---

## 체크리스트

### 업그레이드 전
- [ ] 릴리스 노트 확인
- [ ] Breaking changes 파악
- [ ] 관련 라이브러리 호환성 확인
- [ ] 테스트 커버리지 확인

### 업그레이드 중
- [ ] 단계별 커밋
- [ ] 각 단계별 테스트
- [ ] TypeScript 오류 해결

### 업그레이드 후
- [ ] 전체 테스트 통과
- [ ] 프로덕션 스모크 테스트
- [ ] 성능 회귀 확인
- [ ] 모니터링 확인
