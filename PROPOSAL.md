# Vibe Coding Enterprise Project Template

> AI 기반 개발 환경을 위한 엔터프라이즈급 프로젝트 템플릿

---

## 개요

본 템플릿은 AI Agent(Claude, Cursor, Roo Code 등)를 활용한 "바이브 코딩" 환경에서 엔터프라이즈 수준의 품질, 보안, 일관성을 확보하기 위한 표준화된 프로젝트 구조를 제공합니다.

### 핵심 가치

| 가치 | 설명 |
|------|------|
| **일관성** | 조직 전체에서 동일한 개발 표준과 AI Agent 활용 방식 적용 |
| **품질** | 자동화된 품질 게이트와 코드 리뷰 프로세스 |
| **보안** | OWASP 기반 보안 검증 및 시크릿 관리 체계 |
| **생산성** | AI Agent 최적화된 컨텍스트 제공으로 개발 효율 극대화 |
| **거버넌스** | 엔터프라이즈 정책 준수 및 감사 추적 지원 |

---

## 1. AI Agent 통합 구성

### 1.1 Agent 지시 파일

AI Agent가 프로젝트 컨텍스트를 정확히 이해하고 일관된 출력을 생성하도록 하는 핵심 설정 파일들입니다.

```
.
├── CLAUDE.md              # Claude Code 전용 지시 파일
├── .cursor/rules/         # Cursor AI 규칙 (.mdc 신규 형식)
│   ├── general.mdc        # 기본 규칙 (alwaysApply)
│   ├── typescript.mdc     # TypeScript 전용 (글로브 매칭)
│   ├── python.mdc         # Python 전용 (글로브 매칭)
│   └── architecture.mdc   # Clean Architecture 규칙
├── .cursorrules           # Cursor AI 레거시 (deprecated)
├── .roo/                  # Roo Code 전용 설정 디렉토리
│   ├── rules.md
│   └── rules/general.mdc
└── .agent/
    ├── context.md         # 공통 프로젝트 컨텍스트
    ├── architecture.md    # 아키텍처 설명 문서
    └── conventions.md     # 코딩 컨벤션 문서
```

### 1.2 Agent Skills

재사용 가능한 AI Agent 작업 패턴을 정의합니다.

| Skill | 설명 | 트리거 |
|-------|------|--------|
| `code-review` | PR 코드 리뷰 자동화 | `/review` |
| `test-gen` | 테스트 케이스 자동 생성 | `/test` |
| `doc-gen` | API 문서 자동 생성 | `/doc` |
| `refactor` | 안전한 리팩토링 가이드 | `/refactor` |
| `security-scan` | 보안 취약점 분석 | `/security` |

### 1.3 Subagent 구성

복잡한 작업을 위한 전문화된 서브에이전트 정의:

- **Architect Agent**: 설계 검토 및 아키텍처 의사결정 지원
- **Security Agent**: 보안 취약점 탐지 및 수정 가이드
- **Test Agent**: 테스트 전략 수립 및 TC 생성
- **Documentation Agent**: 기술 문서 작성 및 유지보수

### 1.4 Slash Commands

개발자 생산성을 위한 빠른 명령어 체계:

```bash
/commit          # 컨벤션 기반 커밋 메시지 생성
/pr              # PR 설명 및 체크리스트 자동 생성
/changelog       # 변경 이력 자동 업데이트
/migrate         # 마이그레이션 스크립트 생성
/hotfix          # 긴급 패치 워크플로우 실행
```

---

## 2. GitHub Actions Workflow

### 2.1 CI/CD 파이프라인

```yaml
# 기본 제공 워크플로우
workflows/
├── ci.yml                    # 지속적 통합 (빌드, 테스트, 린트)
├── cd.yml                    # 지속적 배포 (스테이징/프로덕션)
├── release.yml               # 릴리스 자동화 (태깅, 체인지로그)
└── rollback.yml              # 긴급 롤백 프로세스
```

**CI 파이프라인 단계:**

```
코드 푸시 → 린트 검사 → 단위 테스트 → 통합 테스트 → 빌드 → 아티팩트 저장
```

**CD 파이프라인 단계:**

```
PR 승인 → 스테이징 배포 → E2E 테스트 → 수동 승인 → 프로덕션 배포 → 헬스 체크
```

### 2.2 Claude Code 생산성 Workflow

AI Agent 협업을 위한 특화 워크플로우:

| Workflow | 설명 | 트리거 |
|----------|------|--------|
| `claude-pr-review.yml` | Claude를 활용한 자동 PR 리뷰 | PR 생성 시 |
| `claude-issue-triage.yml` | 이슈 자동 분류 및 라벨링 | 이슈 생성 시 |
| `claude-code-suggest.yml` | 코드 개선 제안 | 수동 트리거 |
| `claude-doc-sync.yml` | 코드-문서 동기화 검증 | 주간 스케줄 |

### 2.3 정적 분석 및 보안 Workflow

```yaml
security/
├── sast.yml                  # 정적 애플리케이션 보안 테스트
├── dast.yml                  # 동적 애플리케이션 보안 테스트
├── dependency-scan.yml       # 의존성 취약점 스캔
├── secret-scan.yml           # 시크릿 노출 탐지
├── license-check.yml         # 오픈소스 라이선스 검증
└── container-scan.yml        # 컨테이너 이미지 보안 스캔
```

**보안 게이트 정책:**

- CRITICAL/HIGH 취약점 발견 시 배포 차단
- 신규 의존성 추가 시 라이선스 호환성 검증 필수
- 시크릿 탐지 시 즉시 알림 및 PR 차단

---

## 3. 엔터프라이즈 Repository 구성

### 3.1 코딩 컨벤션 및 Git 규칙

#### 브랜치 전략 (Git Flow 기반)

```
main (protected)
├── develop
│   ├── feature/TICKET-###-description
│   ├── bugfix/TICKET-###-description
│   └── refactor/TICKET-###-description
├── release/v#.#.#
└── hotfix/TICKET-###-description
```

#### 커밋 메시지 컨벤션 (Conventional Commits)

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

**Type 분류:**

| Type | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `docs` | 문서 변경 |
| `style` | 코드 포맷팅 (기능 변화 없음) |
| `refactor` | 리팩토링 |
| `test` | 테스트 추가/수정 |
| `chore` | 빌드, 설정 변경 |
| `perf` | 성능 개선 |
| `security` | 보안 관련 변경 |

#### 코드 스타일 가이드

- **Linter/Formatter**: ESLint, Prettier, Black 등 언어별 표준 도구 적용
- **Pre-commit Hooks**: Husky를 통한 커밋 전 자동 검증
- **EditorConfig**: 에디터 간 일관된 설정 공유

### 3.2 GitHub Organization 및 Repository 구성 규칙

#### Repository 명명 규칙

```
<team>-<product>-<component>
예: platform-auth-service, mobile-app-ios, data-pipeline-etl
```

#### 필수 Repository 설정

| 설정 | 값 | 설명 |
|------|-----|------|
| Branch Protection | main, develop | 직접 푸시 금지, PR 필수 |
| Required Reviews | 최소 2명 | CODEOWNERS 기반 리뷰어 지정 |
| Status Checks | CI 통과 필수 | 테스트, 린트, 보안 스캔 |
| Signed Commits | 권장 | GPG 서명 커밋 |
| Delete Branch on Merge | 활성화 | 머지 후 브랜치 자동 삭제 |

#### CODEOWNERS 설정

```
# 전체 코드베이스
*                       @org/core-team

# 특정 디렉토리별 소유권
/src/auth/              @org/security-team
/src/api/               @org/backend-team
/infrastructure/        @org/devops-team
/.github/workflows/     @org/platform-team
```

### 3.3 소프트웨어 엔지니어링 관점 그라운드 룰

#### 설계 원칙

- **SOLID 원칙** 준수
- **DRY (Don't Repeat Yourself)**: 중복 코드 최소화
- **KISS (Keep It Simple, Stupid)**: 불필요한 복잡성 배제
- **YAGNI (You Ain't Gonna Need It)**: 현재 필요한 것만 구현

#### 기술 부채 관리

```markdown
## 기술 부채 등급
- P0 (Critical): 즉시 해결 필요, 스프린트 내 처리
- P1 (High): 다음 스프린트 내 해결
- P2 (Medium): 분기 내 해결 계획 수립
- P3 (Low): 백로그 관리, 기회 있을 때 해결
```

#### 의존성 관리 정책

- 주간 의존성 업데이트 검토
- Major 버전 업그레이드 시 기술 검토 필수
- 신규 라이브러리 도입 시 보안/라이선스 검토 필수
- EOL(End of Life) 라이브러리 사용 금지

### 3.4 아키텍처 관련 그라운드 룰

#### Architecture Decision Records (ADR)

모든 주요 아키텍처 결정은 ADR로 문서화:

```markdown
# ADR-###: [제목]

## 상태
[제안됨 | 승인됨 | 폐기됨 | 대체됨]

## 컨텍스트
[결정이 필요한 상황 설명]

## 결정
[내린 결정과 그 이유]

## 결과
[예상되는 긍정적/부정적 결과]

## 대안
[검토한 다른 옵션들]
```

#### 서비스 설계 원칙

- **마이크로서비스**: 단일 책임, 느슨한 결합, 높은 응집도
- **API First**: OpenAPI 스펙 먼저 정의 후 구현
- **Event-Driven**: 비동기 통신 우선, 이벤트 소싱 고려
- **12-Factor App**: 클라우드 네이티브 애플리케이션 원칙 준수

#### 비기능 요구사항 (NFR) 기준

| 항목 | 기준 | 측정 방법 |
|------|------|----------|
| 가용성 | 99.9% 이상 | 월간 업타임 모니터링 |
| 응답시간 | P95 < 200ms | APM 대시보드 |
| 처리량 | 1000 TPS 이상 | 부하 테스트 |
| 복구시간 | RTO < 1시간 | DR 훈련 결과 |

### 3.5 테스트 케이스 생성 규칙

#### 테스트 피라미드

```
         /\
        /  \      E2E Tests (10%)
       /----\
      /      \    Integration Tests (20%)
     /--------\
    /          \  Unit Tests (70%)
   --------------
```

#### TC 작성 원칙

- **AAA 패턴**: Arrange → Act → Assert
- **FIRST 원칙**: Fast, Independent, Repeatable, Self-validating, Timely
- **네이밍 규칙**: `should_[예상결과]_when_[조건]`

#### 커버리지 기준

| 유형 | 최소 기준 | 목표 |
|------|----------|------|
| 라인 커버리지 | 70% | 85% |
| 브랜치 커버리지 | 60% | 75% |
| 중요 비즈니스 로직 | 90% | 100% |

#### 테스트 자동화 범위

- 단위 테스트: 모든 비즈니스 로직
- 통합 테스트: API 엔드포인트, DB 연동
- E2E 테스트: 핵심 사용자 시나리오
- 성능 테스트: 주요 API, 배치 작업
- 보안 테스트: 인증/인가, 입력 검증

### 3.6 코드 리뷰 규칙

#### 리뷰 체크리스트

**기능적 측면:**
- [ ] 요구사항을 정확히 구현했는가?
- [ ] 엣지 케이스를 처리했는가?
- [ ] 에러 핸들링이 적절한가?

**코드 품질:**
- [ ] 코딩 컨벤션을 준수했는가?
- [ ] 중복 코드가 없는가?
- [ ] 함수/클래스가 단일 책임을 가지는가?

**보안:**
- [ ] 입력값 검증이 적절한가?
- [ ] 민감 정보가 노출되지 않는가?
- [ ] SQL Injection, XSS 등 취약점이 없는가?

**성능:**
- [ ] N+1 쿼리 문제가 없는가?
- [ ] 불필요한 연산이 없는가?
- [ ] 메모리 누수 가능성이 없는가?

**테스트:**
- [ ] 충분한 테스트가 작성되었는가?
- [ ] 테스트가 올바른 케이스를 검증하는가?

#### 리뷰 에티켓

- **리뷰어**: 건설적인 피드백, 코드에 집중 (사람이 아닌)
- **작성자**: 열린 자세로 피드백 수용, 의도 명확히 설명
- **응답시간**: 24시간 내 최초 리뷰, 48시간 내 전체 리뷰 완료

#### 자동화된 리뷰

- Lint 오류 자동 코멘트
- 테스트 커버리지 변화 리포트
- 보안 취약점 자동 탐지 결과
- AI 기반 코드 개선 제안

### 3.7 AI Agent 사용 규칙

#### 허용되는 사용 사례

- 보일러플레이트 코드 생성
- 테스트 케이스 초안 작성
- 문서화 보조
- 코드 리뷰 1차 검토
- 리팩토링 제안
- 버그 원인 분석

#### 금지되는 사용 사례

- 보안 관련 코드의 무검증 적용
- 프로덕션 데이터를 포함한 프롬프트 사용
- 비밀 키, 토큰 등 민감 정보 노출
- 라이선스 불명확한 코드 복사

#### AI 생성 코드 검증 절차

```
AI 코드 생성 → 개발자 검토 → 단위 테스트 → 보안 스캔 → 코드 리뷰 → 머지
```

#### 책임 소재

- AI 생성 코드의 최종 책임은 **커밋한 개발자**에게 있음
- AI 제안을 그대로 사용하더라도 충분한 이해와 검증 필수
- AI 관련 이슈 발생 시 해당 코드 커밋 이력 추적 가능해야 함

---

## 4. 프로젝트 구조

```
vibe-project-template/
├── .github/
│   ├── workflows/           # GitHub Actions 워크플로우 (12개)
│   ├── ISSUE_TEMPLATE/      # 이슈 템플릿 (3종 + config)
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── CODEOWNERS
│   ├── dependabot.yml
│   ├── labeler.yml          # PR 자동 라벨링 규칙
│   ├── labels.yml           # 라벨 정의
│   └── FUNDING.yml          # 스폰서 설정
├── .agent/                  # AI Agent 공통 설정
│   ├── context.md
│   ├── conventions.md
│   ├── architecture.md
│   ├── guidelines.md
│   ├── commands.md
│   ├── prompts/             # 프롬프트 라이브러리 (15개)
│   ├── skills/              # Agent 스킬 (5개)
│   └── subagents/           # 서브에이전트 (4개)
├── .cursor/rules/           # Cursor AI 규칙 (.mdc 신규 형식)
├── .roo/rules/              # Roo Code 규칙 (.mdc 형식)
├── .vscode/                 # VS Code 설정 템플릿
├── .husky/                  # Git Hooks
├── docs/
│   ├── adr/                 # Architecture Decision Records
│   ├── api/                 # API 문서
│   └── guides/              # 개발 가이드 (8개)
├── examples/
│   ├── typescript-api/      # Express + Prisma 예제
│   └── python-api/          # FastAPI + SQLAlchemy 예제
├── scripts/                 # 유틸리티 스크립트
├── CLAUDE.md                # Claude Code 지시 파일
├── .cursorrules             # Cursor 규칙 (레거시, deprecated)
├── .mcp.json.example        # MCP 설정 템플릿
├── .editorconfig
├── .gitignore
├── .pre-commit-config.yaml
├── CHANGELOG.md             # 변경 이력
├── cliff.toml               # git-cliff 설정
├── CONTRIBUTING.md          # 기여 가이드
├── LICENSE
├── README.md
└── SECURITY.md              # 보안 정책
```

---

## 5. 시작하기

### 5.1 템플릿 사용 방법

1. **GitHub에서 "Use this template" 클릭**
2. **새 Repository 생성**
3. **초기 설정 스크립트 실행**

```bash
# 프로젝트 초기화
./scripts/init-project.sh

# 필수 시크릿 설정 (GitHub Repository Settings)
# - CLAUDE_API_KEY: Claude API 키
# - SONAR_TOKEN: SonarCloud 토큰
# - SNYK_TOKEN: Snyk 토큰
```

### 5.2 커스터마이징

1. `CLAUDE.md` 및 `.cursor/rules/*.mdc` 파일을 프로젝트에 맞게 수정
2. `.github/workflows/` 워크플로우 활성화 및 설정
3. `CODEOWNERS` 파일에 팀 멤버 등록
4. 브랜치 보호 규칙 설정

---

## 6. 로드맵

### Phase 1: Foundation ✅
- [x] 기본 프로젝트 구조 정의
- [x] AI Agent 지시 파일 템플릿
- [x] 핵심 GitHub Actions 워크플로우

### Phase 2: Automation ✅
- [x] Claude PR 리뷰 자동화
- [x] 테스트 자동 생성 파이프라인
- [x] 문서 동기화 검증

### Phase 3: Enterprise Features
- [ ] SSO 연동 가이드
- [ ] 컴플라이언스 리포트 자동화
- [ ] 멀티 레포지토리 거버넌스

---

## 7. 기여하기

본 템플릿의 개선에 기여를 환영합니다. [CONTRIBUTING.md](./CONTRIBUTING.md)를 참조해 주세요.

---

## 8. 라이선스

MIT License - 자세한 내용은 [LICENSE](./LICENSE) 파일을 참조하세요.

---

## 9. 문의

- **Issues**: GitHub Issues를 통해 버그 리포트 및 기능 제안
- **Discussions**: GitHub Discussions를 통해 질문 및 아이디어 공유
