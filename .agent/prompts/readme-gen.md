# README Generation Prompt

## 목적
프로젝트의 README 파일을 작성합니다.

## 컨텍스트
프로젝트의 목적, 기술 스택, 설치 방법 등을 문서화합니다.

---

## 프롬프트 템플릿

```
README를 작성해줘.

### 프로젝트 정보
- 이름: [프로젝트명]
- 설명: [간단한 설명]
- 목적: [프로젝트의 목적]

### 기술 스택
- [기술 1]
- [기술 2]

### 포함할 섹션
- [ ] 프로젝트 소개
- [ ] 주요 기능
- [ ] 설치 방법
- [ ] 사용 방법
- [ ] 환경 변수
- [ ] 프로젝트 구조
- [ ] 기여 방법
- [ ] 라이선스

### 대상 독자
[초보 개발자 / 경험자 / 비개발자 등]
```

---

## 출력 형식

```markdown
# 프로젝트명

[배지들]

[간단한 설명]

## 주요 기능
- [기능 1]
- [기능 2]

## 시작하기

### 요구사항
- [요구사항 1]

### 설치
\`\`\`bash
[설치 명령어]
\`\`\`

### 실행
\`\`\`bash
[실행 명령어]
\`\`\`

## 사용 방법
[사용 예시]

## 환경 변수
| 변수명 | 설명 | 기본값 |
|--------|------|--------|
| ... | ... | ... |

## 프로젝트 구조
\`\`\`
[디렉토리 구조]
\`\`\`

## 기여하기
[기여 가이드]

## 라이선스
[라이선스 정보]
```

---

## 예시

### 입력
```
README를 작성해줘.

### 프로젝트 정보
- 이름: TaskFlow
- 설명: 팀을 위한 실시간 프로젝트 관리 도구
- 목적: 팀의 작업 흐름을 시각화하고 협업 효율 개선

### 기술 스택
- Frontend: React 18, TypeScript, Tailwind CSS
- Backend: Node.js, Express, PostgreSQL
- Infra: Docker, AWS

### 포함할 섹션
- [x] 프로젝트 소개
- [x] 주요 기능
- [x] 설치 방법
- [x] 사용 방법
- [x] 환경 변수
- [x] 프로젝트 구조
- [x] 기여 방법
- [x] 라이선스

### 대상 독자
개발자
```

### 출력
```markdown
# TaskFlow

[![Build Status](https://img.shields.io/github/actions/workflow/status/your-org/taskflow/ci.yml?branch=main)](https://github.com/your-org/taskflow/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue.svg)](https://www.typescriptlang.org/)

팀을 위한 실시간 프로젝트 관리 도구입니다. 칸반 보드, 실시간 협업, 자동화된 워크플로우를 통해 팀의 생산성을 향상시킵니다.

## 주요 기능

- **칸반 보드**: 드래그 앤 드롭으로 작업 상태 관리
- **실시간 협업**: 팀원과 실시간으로 변경사항 공유
- **워크플로우 자동화**: 트리거 기반 자동 작업 할당
- **대시보드**: 팀 성과 및 진행 상황 시각화
- **알림**: Slack, 이메일 연동 알림

## 시작하기

### 요구사항

- Node.js 18+
- PostgreSQL 14+
- Docker (선택)

### 설치

```bash
# 저장소 클론
git clone https://github.com/your-org/taskflow.git
cd taskflow

# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# .env 파일을 수정하여 필요한 값 입력

# 데이터베이스 마이그레이션
npm run db:migrate
```

### 실행

```bash
# 개발 모드
npm run dev

# 프로덕션 빌드
npm run build
npm start
```

### Docker로 실행

```bash
docker-compose up -d
```

## 사용 방법

### 기본 워크플로우

1. **프로젝트 생성**: 대시보드에서 "새 프로젝트" 클릭
2. **보드 설정**: 칼럼(Todo, In Progress, Done 등) 구성
3. **작업 추가**: 카드를 생성하고 팀원에게 할당
4. **진행 추적**: 드래그하여 상태 업데이트

### CLI 사용

```bash
# 작업 목록 조회
taskflow tasks list

# 새 작업 생성
taskflow tasks create --title "버그 수정" --assignee "@john"

# 작업 상태 변경
taskflow tasks move TASK-123 "In Progress"
```

## 환경 변수

| 변수명 | 설명 | 기본값 | 필수 |
|--------|------|--------|------|
| `DATABASE_URL` | PostgreSQL 연결 문자열 | - | Yes |
| `JWT_SECRET` | JWT 서명 키 | - | Yes |
| `PORT` | 서버 포트 | 3000 | No |
| `REDIS_URL` | Redis 연결 (실시간용) | - | No |
| `SLACK_WEBHOOK_URL` | Slack 알림 URL | - | No |

## 프로젝트 구조

```
taskflow/
├── apps/
│   ├── web/                 # React 프론트엔드
│   │   ├── src/
│   │   │   ├── components/  # UI 컴포넌트
│   │   │   ├── hooks/       # 커스텀 훅
│   │   │   ├── pages/       # 페이지 컴포넌트
│   │   │   └── stores/      # 상태 관리
│   │   └── package.json
│   │
│   └── api/                 # Express 백엔드
│       ├── src/
│       │   ├── controllers/ # 요청 핸들러
│       │   ├── services/    # 비즈니스 로직
│       │   ├── models/      # 데이터 모델
│       │   └── middlewares/ # 미들웨어
│       └── package.json
│
├── packages/
│   ├── shared/              # 공유 타입/유틸
│   └── ui/                  # 공유 UI 컴포넌트
│
├── docker-compose.yml
└── package.json
```

## API 문서

API 문서는 서버 실행 후 `/api/docs`에서 확인할 수 있습니다.

또는 [API 문서](./docs/api/README.md)를 참고하세요.

## 기여하기

기여를 환영합니다! 기여하기 전에 [CONTRIBUTING.md](./CONTRIBUTING.md)를 읽어주세요.

### 개발 워크플로우

1. 이 저장소를 포크합니다
2. 기능 브랜치를 생성합니다 (`git checkout -b feature/amazing-feature`)
3. 변경사항을 커밋합니다 (`git commit -m 'feat: Add amazing feature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/amazing-feature`)
5. Pull Request를 생성합니다

### 코드 스타일

- ESLint + Prettier 설정을 따릅니다
- Conventional Commits를 사용합니다
- 테스트 커버리지 80% 이상 유지

## 테스트

```bash
# 전체 테스트
npm test

# 특정 패키지 테스트
npm test --workspace=apps/api

# 커버리지 리포트
npm run test:coverage
```

## 배포

### Docker 배포

```bash
docker build -t taskflow:latest .
docker push your-registry/taskflow:latest
```

### AWS 배포

[배포 가이드](./docs/deployment.md)를 참고하세요.

## 로드맵

- [ ] 모바일 앱 (React Native)
- [ ] GitHub/GitLab 연동
- [ ] 타임 트래킹
- [ ] AI 기반 작업 추천

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](./LICENSE) 파일을 참고하세요.

## 문의

- 이슈: [GitHub Issues](https://github.com/your-org/taskflow/issues)
- 이메일: team@taskflow.dev
- Discord: [TaskFlow Community](https://discord.gg/taskflow)
```

---

## README 체크리스트

- [ ] 프로젝트 목적이 명확한가
- [ ] 설치 방법이 단계별로 설명되어 있는가
- [ ] 필수 환경 변수가 문서화되어 있는가
- [ ] 실행 방법이 명확한가
- [ ] 기여 방법이 안내되어 있는가
- [ ] 라이선스가 명시되어 있는가
- [ ] 배지가 정확한가
