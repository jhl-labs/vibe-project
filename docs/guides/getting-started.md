# Getting Started

> 프로젝트 시작 가이드

## 소개

이 가이드는 프로젝트를 처음 시작하는 개발자를 위한 문서입니다.

## 사전 요구사항

### 필수 소프트웨어

| 소프트웨어 | 최소 버전 | 권장 버전 | 설치 가이드 |
|-----------|----------|----------|-------------|
| Git | 2.30+ | 최신 | [git-scm.com](https://git-scm.com) |
| Node.js | 18.0+ | 20 LTS | [nodejs.org](https://nodejs.org) |
| npm/pnpm | 8.0+/8.0+ | 최신 | Node.js와 함께 설치 |

### 선택적 소프트웨어

| 소프트웨어 | 용도 | 설치 가이드 |
|-----------|------|-------------|
| Docker | 컨테이너 실행 | [docker.com](https://docker.com) |
| VS Code | 코드 편집기 | [code.visualstudio.com](https://code.visualstudio.com) |
| Cursor | AI 코드 편집기 | [cursor.sh](https://cursor.sh) |

## 프로젝트 설정

### 1. 저장소 클론

```bash
# HTTPS
git clone https://github.com/<your-org>/<your-project>.git

# SSH
git clone git@github.com:<your-org>/<your-project>.git

# 프로젝트 디렉토리로 이동
cd <your-project>
```

### 2. 의존성 설치

```bash
# npm 사용
npm install

# 또는 pnpm 사용
pnpm install

# 또는 yarn 사용
yarn install
```

### 3. 환경 변수 설정

```bash
# 환경 변수 템플릿 복사 (예제 프로젝트 참조)
# TypeScript: examples/typescript-api/.env.example
# Python: examples/python-api/.env.example
cp .env.example .env

# .env 파일 편집
# 필요한 값을 설정하세요
```

#### 필수 환경 변수

| 변수명 | 설명 | 예시 |
|--------|------|------|
| DATABASE_URL | 데이터베이스 연결 문자열 | postgresql://localhost:5432/db |
| API_KEY | 외부 서비스 API 키 | your-api-key |
| NODE_ENV | 환경 구분 | development |

### 4. 데이터베이스 설정 (해당되는 경우)

```bash
# 데이터베이스 마이그레이션
npm run db:migrate

# 시드 데이터 추가 (선택)
npm run db:seed
```

### 5. 개발 서버 실행

```bash
# 개발 서버 시작
npm run dev

# 서버가 http://localhost:3000 에서 실행됩니다
```

## 프로젝트 구조

```
.
├── src/                    # 소스 코드
│   ├── domain/             # 비즈니스 로직
│   ├── application/        # 유스케이스
│   ├── infrastructure/     # 외부 연동
│   └── presentation/       # API/UI
├── tests/                  # 테스트 코드
├── docs/                   # 문서
├── scripts/                # 유틸리티 스크립트
└── config/                 # 설정 파일
```

각 디렉토리의 상세 설명은 [development.md](./development.md)를 참조하세요.

## 기본 명령어

### 개발

```bash
# 개발 서버 실행
npm run dev

# 타입 체크
npm run type-check

# 린트
npm run lint

# 포맷팅
npm run format
```

### 테스트

```bash
# 전체 테스트 실행
npm test

# 테스트 watch 모드
npm run test:watch

# 커버리지 리포트
npm run test:coverage
```

### 빌드

```bash
# 프로덕션 빌드
npm run build

# 빌드 결과 실행
npm start
```

## IDE 설정

### VS Code 권장 확장

프로젝트 루트의 `.vscode/extensions.json`에 정의되어 있습니다:

- ESLint
- Prettier
- EditorConfig
- GitLens

### VS Code 설정

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

## AI 에이전트 사용

### Claude Code

```bash
# Claude Code 실행
claude

# CLAUDE.md에 프로젝트 지침이 정의되어 있습니다
```

### Cursor AI

1. Cursor에서 프로젝트 열기
2. `.cursor/rules/*.mdc` 파일이 자동으로 로드됩니다
   - `general.mdc` - 모든 파일에 적용되는 기본 규칙
   - `typescript.mdc` - TypeScript/JavaScript 파일 전용 규칙
   - `python.mdc` - Python 파일 전용 규칙
   - `architecture.mdc` - Clean Architecture 레이어 규칙

> **참고**: `.cursorrules` 파일은 호환성을 위해 유지되지만 **deprecated** 됨.
> 새로운 `.cursor/rules/*.mdc` 형식을 사용하세요.

### Roo Code

1. Roo Code에서 프로젝트 열기
2. `.roo/rules.md` 및 `.roo/rules/*.mdc` 파일이 로드됩니다

## 문제 해결

### 일반적인 문제

#### 의존성 설치 실패

```bash
# node_modules 삭제 후 재설치
rm -rf node_modules
npm install
```

#### 포트 충돌

```bash
# 사용 중인 포트 확인
lsof -i :3000          # macOS / Linux (lsof 설치 필요)
ss -tlnp | grep :3000  # Linux 대안

# 다른 포트로 실행
PORT=3001 npm run dev
```

#### 데이터베이스 연결 실패

1. 데이터베이스 서버가 실행 중인지 확인
2. `.env`의 DATABASE_URL이 올바른지 확인
3. 방화벽/네트워크 설정 확인

### 도움 받기

- [GitHub Issues](https://github.com/<your-org>/<your-project>/issues)
- [Discussions](https://github.com/<your-org>/<your-project>/discussions)
- 팀 Slack 채널: #project-support

## 다음 단계

1. [개발 가이드](./development.md) 읽기
2. [아키텍처 문서](../adr/) 확인
3. [API 문서](../api/) 검토
4. 첫 번째 이슈 해결해보기

---

**Tip**: 문제가 발생하면 먼저 문서를 확인하고, 그래도 해결되지 않으면 팀에 문의하세요.
