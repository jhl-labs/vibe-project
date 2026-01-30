# 🚀 Vibe Project Template

> **AI Agent와 함께하는 엔터프라이즈급 개발 환경 템플릿**

[![Use this template](https://img.shields.io/badge/Use%20this-template-2ea44f?style=for-the-badge)](https://github.com/<your-org>/<your-project>/generate)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

[![CI](https://github.com/<your-org>/<your-project>/actions/workflows/ci.yml/badge.svg)](https://github.com/<your-org>/<your-project>/actions/workflows/ci.yml)
[![Security Scan](https://github.com/<your-org>/<your-project>/actions/workflows/security-scan.yml/badge.svg)](https://github.com/<your-org>/<your-project>/actions/workflows/security-scan.yml)

---

## 🎯 Vibe Coding이란?

**Vibe Coding**은 AI Agent(Claude, Cursor, Copilot 등)와 협업하여 개발하는 새로운 방법론입니다.

```
개발자의 의도(Vibe) + AI의 구현력 = 생산성 극대화
```

이 템플릿은 Vibe Coding을 위한 **표준화된 환경**을 제공합니다:
- AI가 프로젝트를 이해할 수 있는 컨텍스트
- 일관된 코드 생성을 위한 규칙
- 검증된 프롬프트 템플릿
- 자동화된 품질 관리

---

## ✨ 주요 기능

### 🤖 AI Agent 지원
| Agent | 설정 파일 | 설명 |
|-------|----------|------|
| **Claude Code** | `CLAUDE.md` | Anthropic Claude CLI |
| **Cursor AI** | `.cursor/rules/*.mdc` | VS Code 기반 AI IDE |
| **Roo Code** | `.roo/rules/*.mdc` | AI 코딩 어시스턴트 |

### 📚 프롬프트 라이브러리
14개의 검증된 프롬프트 템플릿 제공:
- API 설계, 버그 수정, 코드 리뷰
- 리팩토링, 보안 검토, 성능 분석
- 테스트 생성, 마이그레이션, 문서화

### 🔧 개발 환경
- **VS Code 설정**: 확장, 스니펫, 디버그, 태스크
- **Git Hooks**: Conventional Commits 강제
- **Pre-commit**: 린트, 시크릿 스캔, 포맷팅
- **MCP 지원**: Model Context Protocol 설정

### 🔄 GitHub 자동화
- **CI/CD**: 빌드, 테스트, 배포 파이프라인
- **Claude PR Review**: AI 코드 리뷰
- **Security Scan**: 보안 취약점 자동 검사
- **Issue Triage**: 이슈 자동 분류

### 📖 예제 프로젝트
| 예제 | 기술 스택 | 아키텍처 |
|------|----------|----------|
| TypeScript API | Express, Prisma, Jest | Clean Architecture |
| Python API | FastAPI, SQLAlchemy, Pytest | Clean Architecture |

---

## 🚀 시작하기

### 전제 조건

- Git 2.x+
- 선택적: Node.js 18+ / Python 3.11+
- 선택적: [Claude Code](https://claude.ai/code) / [Cursor](https://cursor.sh)

### 1단계: 템플릿으로 저장소 생성

**방법 A: GitHub UI**
1. 이 페이지 상단의 **"Use this template"** 버튼 클릭
2. 새 저장소 이름 입력
3. **"Create repository"** 클릭

**방법 B: GitHub CLI**
```bash
gh repo create my-project --template <your-org>/vibe-project-template --clone
cd my-project
```

### 2단계: 프로젝트 초기화

```bash
# 초기화 스크립트 실행
./scripts/init-project.sh
```

대화형 설정:
1. 프로젝트 정보 입력 (이름, 조직, 설명)
2. AI Agent 선택 (Claude, Cursor, Roo)
3. 예제 프로젝트 선택 (선택적)
4. MCP 설정 (선택적)

### 3단계: AI와 개발 시작

```bash
# Claude Code 사용
claude

# Cursor 사용
cursor .

# VS Code 사용
code .
```

---

## 📁 프로젝트 구조

```
vibe-project-template/
│
├── 🤖 AI Agent 설정
│   ├── CLAUDE.md                 # Claude Code 지시사항
│   ├── .cursor/rules/*.mdc       # Cursor AI 규칙 (신규 형식)
│   ├── .cursorrules              # Cursor AI 규칙 (레거시)
│   ├── .roo/rules/*.mdc          # Roo Code 규칙
│   └── .mcp.json.example         # MCP 설정 템플릿
│
├── 📂 .agent/                    # AI 컨텍스트
│   ├── context.md                # 프로젝트 컨텍스트
│   ├── conventions.md            # 코딩 컨벤션
│   ├── architecture.md           # 아키텍처 설명
│   ├── prompts/                  # 프롬프트 라이브러리 (14개)
│   ├── skills/                   # Agent 스킬 정의
│   └── subagents/                # 전문 서브에이전트
│
├── 📂 .github/                   # GitHub 설정
│   ├── workflows/                # CI/CD 파이프라인 (12개)
│   ├── ISSUE_TEMPLATE/           # 이슈 템플릿
│   └── PULL_REQUEST_TEMPLATE.md
│
├── 📂 .vscode/                   # VS Code 설정
│   ├── extensions.json           # 권장 확장
│   ├── settings.json             # 에디터 설정
│   ├── launch.json               # 디버그 구성
│   ├── tasks.json                # 빌드 태스크
│   └── snippets.code-snippets    # 코드 스니펫
│
├── 📂 docs/                      # 문서
│   ├── adr/                      # Architecture Decision Records
│   ├── api/                      # API 문서
│   └── guides/                   # 가이드 (8개)
│
├── 📂 examples/                  # 예제 프로젝트
│   ├── typescript-api/           # Express + Prisma
│   └── python-api/               # FastAPI + SQLAlchemy
│
├── 📂 scripts/                   # 유틸리티
│   └── init-project.sh           # 프로젝트 초기화
│
└── 📂 .husky/                    # Git Hooks
    ├── pre-commit                # 커밋 전 검사
    └── commit-msg                # 커밋 메시지 검증
```

---

## 📖 문서

### 가이드
| 문서 | 설명 |
|------|------|
| [시작 가이드](docs/guides/getting-started.md) | 첫 번째 단계 |
| [개발 가이드](docs/guides/development.md) | 개발 워크플로우 |
| [AI Agent 가이드](docs/guides/ai-agent-usage.md) | AI 활용법 |
| [커스터마이징](docs/guides/customization.md) | 템플릿 수정 |
| [MCP 설정](docs/guides/mcp-setup.md) | MCP 구성 |
| [효과 측정](docs/guides/effectiveness-measurement.md) | KPI 및 측정 |
| [GitHub 설정](docs/guides/github-setup-checklist.md) | 저장소 설정 |
| [FAQ](docs/guides/faq.md) | 자주 묻는 질문 |

### 기타
| 문서 | 설명 |
|------|------|
| [기여 가이드](CONTRIBUTING.md) | 프로젝트 기여 방법 |
| [보안 정책](SECURITY.md) | 취약점 보고 |
| [변경 이력](CHANGELOG.md) | 버전별 변경사항 |

---

## 🎨 프롬프트 라이브러리

`.agent/prompts/` 디렉토리에서 검증된 프롬프트를 찾아보세요:

```bash
# 사용 예시 (Claude Code)
@.agent/prompts/bug-fix.md 를 참고해서 이 버그를 수정해줘
```

| 프롬프트 | 용도 |
|----------|------|
| `api-design.md` | REST API 설계 |
| `bug-fix.md` | 버그 분석 및 수정 |
| `code-review.md` | 코드 리뷰 |
| `feature-implement.md` | 기능 구현 |
| `refactor.md` | 코드 리팩토링 |
| `security-review.md` | 보안 검토 |
| `test-generation.md` | 테스트 작성 |
| `migration.md` | 마이그레이션 |
| [전체 목록](.agent/prompts/README.md) | 14개 프롬프트 |

---

## 🔧 커스터마이징

### AI Agent 규칙 수정

```bash
# Claude Code
vim CLAUDE.md

# Cursor AI (.cursor/rules/*.mdc - 신규 형식 권장)
vim .cursor/rules/general.mdc

# Roo Code
vim .roo/rules/general.mdc
```

### 프로젝트 컨텍스트 수정

```bash
# 프로젝트 설명
vim .agent/context.md

# 코딩 컨벤션
vim .agent/conventions.md

# 아키텍처
vim .agent/architecture.md
```

### 워크플로우 활성화/비활성화

```bash
# .github/workflows/ 에서 필요한 워크플로우만 유지
# 불필요한 워크플로우는 삭제 또는 이름에 .disabled 추가
```

---

## 🤝 기여하기

기여를 환영합니다! [CONTRIBUTING.md](CONTRIBUTING.md)를 참조하세요.

1. Fork
2. Feature branch (`git checkout -b feature/amazing`)
3. Commit (`git commit -m 'feat: Add amazing feature'`)
4. Push (`git push origin feature/amazing`)
5. Pull Request

---

## 📄 라이선스

이 프로젝트는 [MIT 라이선스](LICENSE)를 따릅니다.

---

## 💡 Vibe Coding 팁

> "AI에게 **무엇을** 원하는지 명확히 전달하세요. **어떻게** 할지는 AI가 알아서 합니다."

1. **컨텍스트 제공**: `.agent/context.md`를 최신 상태로 유지
2. **작은 단위로 요청**: 한 번에 하나의 작업만 요청
3. **프롬프트 활용**: 검증된 프롬프트 템플릿 사용
4. **결과 검토**: AI 출력물은 항상 검토 후 적용

---

<p align="center">
  <strong>Made with 💜 for Vibe Coding</strong>
</p>
