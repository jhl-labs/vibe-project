# Customization Guide

> 프로젝트 템플릿 커스터마이징 가이드

## 개요

이 템플릿은 언어와 플랫폼에 독립적으로 설계되었습니다. 프로젝트의 기술 스택에 맞게 커스터마이징하여 사용하세요.

## 필수 커스터마이징

템플릿 사용 시 **반드시** 수정해야 하는 항목들입니다.

### 1. 플레이스홀더 교체

`scripts/init-project.sh`를 실행하거나, 수동으로 다음 플레이스홀더를 교체하세요:

| 플레이스홀더 | 설명 | 예시 |
|-------------|------|------|
| `<your-org>` | GitHub 조직/사용자명 | `my-company` |
| `<your-project>` | 프로젝트명 | `awesome-service` |
| `<your-name-or-organization>` | 라이선스 소유자 | `My Company Inc.` |
| `<year>` | 연도 | `2024` |
| `<your-domain>` | 도메인 | `mycompany.com` |

**영향받는 파일:**
- `README.md`
- `LICENSE`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `.github/CODEOWNERS`
- `.github/dependabot.yml`
- `.github/ISSUE_TEMPLATE/config.yml`

### 2. CLAUDE.md 수정

프로젝트에 맞게 AI Agent 지시사항을 업데이트하세요:

```markdown
## 프로젝트 개요
이 프로젝트는 `<실제 프로젝트 설명>`입니다.

## 기술 스택
- **언어**: TypeScript / Python / Go / etc.
- **프레임워크**: Next.js / FastAPI / Gin / etc.
- **데이터베이스**: PostgreSQL / MongoDB / etc.
```

### 3. .agent/context.md 수정

프로젝트 컨텍스트 정보를 실제 내용으로 업데이트하세요.

---

## 언어별 커스터마이징

### TypeScript/JavaScript

#### 추가 파일 생성

```bash
# package.json
npm init -y

# TypeScript 설정
npx tsc --init

# ESLint & Prettier
npm install -D eslint prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

#### 권장 설정 파일

**`.eslintrc.js`**
```javascript
module.exports = {
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
  ],
  rules: {
    // 프로젝트 규칙
  },
};
```

**`.prettierrc`**
```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
```

**`tsconfig.json`**
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

#### Dependabot 활성화

`.github/dependabot.yml`에서 npm 섹션 주석 해제:

```yaml
- package-ecosystem: "npm"
  directory: "/"
  schedule:
    interval: "weekly"
```

#### CI 워크플로우 수정

`.github/workflows/ci.yml`에서 Node.js 섹션 활성화:

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'

- name: Install dependencies
  run: npm ci

- name: Run linter
  run: npm run lint

- name: Run tests
  run: npm test
```

---

### Python

#### 추가 파일 생성

```bash
# pyproject.toml (권장)
touch pyproject.toml

# 또는 requirements.txt
touch requirements.txt
touch requirements-dev.txt

# 가상 환경
python -m venv venv
source venv/bin/activate
```

#### 권장 설정 파일

**`pyproject.toml`**
```toml
[project]
name = "your-project"
version = "0.1.0"
requires-python = ">=3.11"

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W"]

[tool.mypy]
python_version = "3.11"
strict = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = "test_*.py"
```

**`requirements.txt`**
```
# Production dependencies
```

**`requirements-dev.txt`**
```
-r requirements.txt
ruff
mypy
pytest
pytest-cov
```

#### Dependabot 활성화

`.github/dependabot.yml`에서 pip 섹션 주석 해제.

#### CI 워크플로우 수정

```yaml
- name: Setup Python
  uses: actions/setup-python@v5
  with:
    python-version: '3.12'

- name: Install dependencies
  run: |
    pip install -r requirements-dev.txt

- name: Run Ruff
  run: ruff check .

- name: Run tests
  run: pytest --cov
```

---

### Go

#### 추가 파일 생성

```bash
# Go 모듈 초기화
go mod init github.com/<your-org>/<your-project>

# 기본 구조
mkdir -p cmd pkg internal
```

#### 권장 설정 파일

**`.golangci.yml`**
```yaml
linters:
  enable:
    - gofmt
    - golint
    - govet
    - errcheck
    - staticcheck

linters-settings:
  gofmt:
    simplify: true
```

#### CI 워크플로우 수정

```yaml
- name: Setup Go
  uses: actions/setup-go@v5
  with:
    go-version: '1.22'

- name: Run tests
  run: go test -v -race -coverprofile=coverage.out ./...

- name: Run linter
  uses: golangci/golangci-lint-action@v4
```

---

## 프레임워크별 커스터마이징

### Next.js

```bash
npx create-next-app@latest . --typescript --tailwind --eslint
```

`CLAUDE.md`에 추가:
```markdown
## 프레임워크
- Next.js 14 (App Router)
- Tailwind CSS

## 디렉토리 구조
- `app/`: 페이지 및 라우팅
- `components/`: 재사용 컴포넌트
- `lib/`: 유틸리티
```

### FastAPI

```bash
pip install fastapi uvicorn sqlalchemy
```

`CLAUDE.md`에 추가:
```markdown
## 프레임워크
- FastAPI
- SQLAlchemy (ORM)
- Pydantic (Validation)

## 디렉토리 구조
- `app/api/`: API 라우터
- `app/models/`: DB 모델
- `app/schemas/`: Pydantic 스키마
- `app/services/`: 비즈니스 로직
```

### NestJS

```bash
npm i -g @nestjs/cli
nest new . --skip-git
```

### Spring Boot

```bash
# Spring Initializr 사용
curl https://start.spring.io/starter.zip -d dependencies=web,jpa -o project.zip
```

---

## Docker 지원 추가

### Dockerfile

```dockerfile
# Node.js 예시
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### docker-compose.yml

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### .dockerignore

```
node_modules
dist
.git
.env
*.log
```

---

## 인프라 지원 추가

### Terraform

```
infrastructure/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
```

### Kubernetes

```
k8s/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    ├── development/
    ├── staging/
    └── production/
```

---

## AI Agent 컨텍스트 확장

### 도메인 용어집 추가

`.agent/glossary.md` 생성:
```markdown
# 도메인 용어집

| 용어 | 정의 |
|------|------|
| Order | 주문 엔터티 |
| SKU | Stock Keeping Unit |
```

### 프로젝트별 스킬 추가

`.agent/skills/` 디렉토리에 프로젝트 특화 스킬 추가:
```markdown
# Custom Skill: generate-api

이 프로젝트의 API 생성 규칙:
1. RESTful 컨벤션 준수
2. OpenAPI 스펙 먼저 작성
3. DTO 클래스 자동 생성
```

---

## 체크리스트

### 초기 설정

- [ ] 플레이스홀더 교체 완료
- [ ] `CLAUDE.md` 프로젝트 정보 업데이트
- [ ] `.agent/context.md` 업데이트
- [ ] `.cursorrules` 언어별 규칙 추가
- [ ] `.roo/rules.md` 업데이트

### 언어/프레임워크 설정

- [ ] 패키지 매니저 설정 (package.json, pyproject.toml 등)
- [ ] 린터/포매터 설정
- [ ] 테스트 프레임워크 설정
- [ ] CI 워크플로우 언어별 단계 활성화
- [ ] Dependabot 언어별 설정 활성화

### 선택적 설정

- [ ] Dockerfile 추가
- [ ] docker-compose.yml 추가
- [ ] 인프라 코드 추가 (Terraform, K8s)
- [ ] 환경별 설정 파일 추가

---

## 참고

- [시작 가이드](./getting-started.md)
- [개발 가이드](./development.md)
- [FAQ](./faq.md)
