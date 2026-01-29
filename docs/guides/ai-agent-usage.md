# AI Agent 사용 가이드

> 이 템플릿에서 지원하는 AI 코딩 에이전트 설정 및 사용법

## 지원 AI 에이전트

| 에이전트 | 설정 파일 | 설정 위치 |
|---------|----------|----------|
| Claude Code | `CLAUDE.md` | 프로젝트 루트 |
| Cursor AI | `.cursor/rules/*.mdc` | `.cursor/rules/` |
| Roo Code | `.roo/rules.md`, `.roo/rules/*.mdc` | `.roo/` |
| 공통 | `.agent/` | `.agent/` |

---

## Claude Code

### 설정 파일: `CLAUDE.md`

Claude Code는 대화 시작 시 `CLAUDE.md`를 자동으로 로드합니다.

```
CLAUDE.md              # 프로젝트 지침 (Git 추적)
CLAUDE.local.md        # 개인 설정 (.gitignore에 추가)
.claude/CLAUDE.md      # 대체 위치
```

### 주요 기능

- `/init` 명령어로 `CLAUDE.md` 자동 생성
- `#` 키를 눌러 대화 중 `CLAUDE.md`에 지시사항 추가
- `CLAUDE.local.md`로 개인 설정 분리 (`.gitignore`에 추가 권장)

### 커스터마이징

`CLAUDE.md`에서 다음을 프로젝트에 맞게 수정하세요:

1. **프로젝트 개요**: 이름, 설명, 기술 스택
2. **빠른 명령어**: 설치, 실행, 테스트, 빌드 명령
3. **프로젝트 구조**: 디렉토리 레이아웃
4. **코딩 규칙**: 네이밍, 스타일, 아키텍처 원칙

### 팁

- `CLAUDE.md`는 간결하게 유지 — 모든 줄이 실제 작업과 경쟁합니다
- 상세한 컨텍스트는 `.agent/context.md`에 분리
- MCP 서버 설정은 `.mcp.json`에서 관리

---

## Cursor AI

### 설정 파일: `.cursor/rules/*.mdc` (신규 형식)

> **중요**: `.cursorrules` 파일은 **deprecated** 되었습니다.
> Cursor는 향후 릴리스에서 이 형식의 지원을 제거할 예정입니다.
> `.cursor/rules/*.mdc` 형식으로 마이그레이션하세요.

### .mdc 파일 형식

```markdown
---
description: 규칙 설명
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---

# Rule Title

규칙 내용...
```

#### Frontmatter 필드

| 필드 | 설명 | 예시 |
|------|------|------|
| `description` | 규칙의 목적 | `"TypeScript coding rules"` |
| `globs` | 적용 대상 파일 패턴 | `["**/*.ts", "**/*.py"]` |
| `alwaysApply` | 항상 적용 여부 | `true` / `false` |

### 포함된 규칙 파일

| 파일 | 적용 대상 | 설명 |
|------|----------|------|
| `general.mdc` | 모든 파일 (`alwaysApply: true`) | 기본 코딩 규칙, 보안, Git |
| `typescript.mdc` | `*.ts`, `*.tsx`, `*.js`, `*.jsx` | TS/JS 전용 규칙 |
| `python.mdc` | `*.py` | Python 전용 규칙 (PEP 8, type hints) |
| `architecture.mdc` | `domain/`, `application/` 등 | Clean Architecture 레이어 규칙 |

### 커스터마이징

프로젝트에 맞는 `.mdc` 파일을 추가할 수 있습니다:

```bash
# 예: React 컴포넌트 규칙
cat > .cursor/rules/react.mdc << 'EOF'
---
description: React component rules
globs: ["**/components/**/*.tsx", "**/pages/**/*.tsx"]
alwaysApply: false
---

# React Component Rules

- Use functional components with hooks
- Props interface above component definition
- ...
EOF
```

### .cursorrules에서 마이그레이션

1. `.cursorrules`의 규칙을 카테고리별로 분리
2. 각 카테고리에 맞는 `.mdc` 파일 생성
3. 적절한 `globs` 패턴 설정
4. `.cursorrules`는 호환성을 위해 유지 (선택)

---

## Roo Code

### 설정 파일

```
.roo/
├── rules.md              # 기본 규칙
└── rules/
    └── general.mdc       # .mdc 형식 규칙
```

### .mdc 지원

Roo Code도 `.mdc` 파일 형식을 지원합니다. Cursor와 규칙을 공유하려면 심볼릭 링크를 사용하세요:

```bash
# Cursor 규칙을 Roo Code에 연결
ln -s ../../.cursor/rules/general.mdc .roo/rules/general.mdc
ln -s ../../.cursor/rules/typescript.mdc .roo/rules/typescript.mdc
```

### 커스터마이징

`.roo/rules.md`에서 프로젝트 정보를 업데이트하세요:

- Project Information (이름, 타입, 언어, 프레임워크)
- Naming Conventions
- Code Organization
- Security Rules

---

## 공통 에이전트 컨텍스트 (`.agent/`)

모든 AI 에이전트가 참조할 수 있는 공통 컨텍스트 파일입니다.

### 디렉토리 구조

```
.agent/
├── context.md          # 프로젝트 컨텍스트 (기술 스택, 아키텍처)
├── conventions.md      # 코딩 컨벤션 상세
├── architecture.md     # 아키텍처 설명
├── guidelines.md       # 개발 가이드라인
├── commands.md         # 주요 명령어 레퍼런스
├── skills/             # AI 에이전트 스킬 정의
│   ├── code-review.md
│   ├── test-gen.md
│   ├── doc-gen.md
│   ├── refactor.md
│   └── security-scan.md
├── subagents/          # 서브 에이전트 역할 정의
│   ├── architect.md
│   ├── security.md
│   ├── test.md
│   └── documentation.md
└── prompts/            # 프롬프트 라이브러리
    ├── README.md
    ├── feature-implement.md
    ├── architecture-decision.md
    ├── code-review.md
    ├── bug-fix.md
    ├── refactor.md
    └── ...
```

### 프롬프트 라이브러리 사용법

`prompts/` 디렉토리에 재사용 가능한 프롬프트 템플릿이 있습니다. AI 에이전트에게 다음과 같이 요청하세요:

```
@.agent/prompts/feature-implement.md 를 참고해서 사용자 인증 기능을 구현해줘
```

각 프롬프트 파일에는 다음이 포함됩니다:
- **목적**: 프롬프트의 사용 시나리오
- **사용법**: 실행 방법 및 변수 설명
- **프롬프트 본문**: 구조화된 지시사항
- **출력 포맷**: 기대되는 결과 형식
- **체크리스트**: 완료 확인 항목

---

## MCP (Model Context Protocol)

### 설정 파일: `.mcp.json`

MCP 서버를 통해 AI 에이전트에 추가 도구를 제공할 수 있습니다.

```bash
# 설정 템플릿 복사
cp .mcp.json.example .mcp.json

# 프로젝트에 맞게 수정
```

상세 설정은 [MCP 설정 가이드](./mcp-setup.md)를 참조하세요.

---

## 에이전트 간 설정 우선순위

각 AI 에이전트는 다음 순서로 설정을 로드합니다:

### Claude Code
1. `CLAUDE.md` (프로젝트 루트)
2. `CLAUDE.local.md` (개인 설정, Git 비추적)
3. `.claude/CLAUDE.md` (대체 위치)

### Cursor AI
1. `.cursor/rules/*.mdc` (글로브 매칭 규칙)
2. `.cursorrules` (레거시, deprecated)

### Roo Code
1. `.roo/rules.md` (기본 규칙)
2. `.roo/rules/*.mdc` (글로브 매칭 규칙)

### 공통 참조
모든 에이전트에서 `.agent/` 디렉토리의 파일을 컨텍스트로 참조 가능:
- `@.agent/context.md` (Cursor)
- `.agent/context.md` 파일 읽기 (Claude Code)

---

## 초기 설정 체크리스트

- [ ] `CLAUDE.md` - 프로젝트 정보 업데이트
- [ ] `.cursor/rules/general.mdc` - 프로젝트 정보 업데이트
- [ ] `.roo/rules.md` - 프로젝트 정보 업데이트
- [ ] `.agent/context.md` - 기술 스택, 아키텍처 작성
- [ ] `.agent/conventions.md` - 코딩 컨벤션 확정
- [ ] `.mcp.json` - 필요한 MCP 서버 설정 (선택)
- [ ] 언어별 `.mdc` 규칙 추가/수정 (선택)

---

## 참고

- [시작 가이드](./getting-started.md)
- [커스터마이징 가이드](./customization.md)
- [MCP 설정 가이드](./mcp-setup.md)
- [효과 측정 가이드](./effectiveness-measurement.md)
