# FAQ (자주 묻는 질문)

> Vibe Project Template 관련 자주 묻는 질문과 답변

---

## 일반

### Q: 이 템플릿은 어떤 프로젝트에 적합한가요?

**A:** AI Agent(Claude, Cursor, Roo Code 등)를 활용한 개발 환경을 구축하려는 모든 프로젝트에 적합합니다. 언어와 프레임워크에 독립적으로 설계되어 있어, 프로젝트 기술 스택에 맞게 커스터마이징하여 사용할 수 있습니다.

---

### Q: 특정 언어(Node.js, Python 등) 설정이 없는 이유는?

**A:** 이 템플릿은 **AI Agent 협업**에 초점을 맞춘 템플릿입니다. 언어별 설정은 프로젝트마다 다르기 때문에 의도적으로 제외했습니다.

언어별 설정 방법은 [커스터마이징 가이드](./customization.md)를 참조하세요.

---

### Q: `scripts/init-project.sh`는 무엇을 하나요?

**A:** 프로젝트 초기화 스크립트입니다. 다음 작업을 수행합니다:

1. 프로젝트 정보 입력 (이름, 조직명 등)
2. 플레이스홀더(`<your-org>`, `<your-project>` 등) 자동 교체
3. Git hooks 설정
4. 환경 파일 생성 (`.env`)
5. 선택적 의존성 설치

```bash
./scripts/init-project.sh
```

---

## AI Agent

### Q: CLAUDE.md와 .cursorrules의 차이점은?

**A:**

| 파일 | 대상 | 용도 |
|------|------|------|
| `CLAUDE.md` | Claude Code | 상세한 프로젝트 지침, 아키텍처, 컨벤션 |
| `.cursorrules` | Cursor AI | 간결한 코드 생성 규칙 |
| `.roo/rules.md` | Roo Code | Roo 전용 규칙 |

세 파일 모두 `.agent/` 디렉토리의 공통 컨텍스트를 참조합니다.

---

### Q: .agent/ 디렉토리 구조는 어떻게 되나요?

**A:**
```
.agent/
├── context.md       # 프로젝트 컨텍스트 (기본 정보, 기술 스택)
├── conventions.md   # 코딩 컨벤션
├── architecture.md  # 아키텍처 설명
├── guidelines.md    # AI 사용 가이드라인
├── commands.md      # Slash commands 가이드
├── skills/          # 재사용 가능한 AI 작업 패턴
│   ├── code-review.md
│   ├── test-gen.md
│   ├── doc-gen.md
│   ├── refactor.md
│   └── security-scan.md
└── subagents/       # 전문화된 서브에이전트
    ├── architect.md
    ├── security.md
    ├── test.md
    └── documentation.md
```

---

### Q: AI Agent 사용 시 보안 주의사항은?

**A:** `.agent/guidelines.md`에 상세히 정리되어 있습니다. 핵심 사항:

**금지:**
- 프로덕션 데이터를 프롬프트에 포함
- API 키, 비밀번호 등 시크릿 노출
- AI 생성 코드 무검증 적용

**필수:**
- 모든 AI 생성 코드는 개발자 검토 필수
- 보안 관련 코드는 보안팀 리뷰 필수
- AI 생성 코드의 책임은 커밋한 개발자에게 있음

---

### Q: Slash Commands는 어떻게 사용하나요?

**A:** AI 에이전트에게 특정 작업을 요청하는 단축 명령어입니다:

```
/commit    - 커밋 메시지 생성
/pr        - PR 설명 생성
/review    - 코드 리뷰
/test      - 테스트 케이스 생성
/doc       - 문서 생성
/refactor  - 리팩토링 제안
/security  - 보안 스캔
```

상세 사용법은 `.agent/commands.md`를 참조하세요.

---

## GitHub Workflows

### Q: CI가 실패합니다. 어떻게 해야 하나요?

**A:** 기본 CI 워크플로우는 플레이스홀더 상태입니다. 프로젝트 언어에 맞게 `.github/workflows/ci.yml`을 수정해야 합니다.

[커스터마이징 가이드](./customization.md#ci-워크플로우-수정)를 참조하세요.

---

### Q: Claude PR Review가 작동하지 않습니다.

**A:** `ANTHROPIC_API_KEY` 시크릿이 필요합니다.

1. [Anthropic Console](https://console.anthropic.com/)에서 API 키 생성
2. Repository Settings > Secrets and variables > Actions
3. `ANTHROPIC_API_KEY` 시크릿 추가

---

### Q: Dependabot이 PR을 생성하지 않습니다.

**A:** `.github/dependabot.yml`에서 사용하는 패키지 에코시스템의 주석을 해제하세요.

```yaml
# npm 사용 시
- package-ecosystem: "npm"
  directory: "/"
  schedule:
    interval: "weekly"
```

---

### Q: Security Scan에서 오류가 발생합니다.

**A:** CodeQL은 지원하는 언어가 정해져 있습니다. `.github/workflows/security-scan.yml`에서 언어를 프로젝트에 맞게 수정하세요:

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: javascript  # 또는 python, java, go 등
```

---

## Git & 커밋

### Q: 커밋 메시지가 거부됩니다.

**A:** `.husky/commit-msg` 훅이 Conventional Commits 형식을 강제합니다.

**올바른 형식:**
```
feat(auth): add login functionality
fix(api): resolve null pointer exception
docs: update README
```

**틀린 형식:**
```
Added login feature       # 타입 없음
feat: Add login feature.  # 마침표 있음
FEAT(auth): add login     # 대문자 타입
```

---

### Q: pre-commit 훅을 건너뛰고 싶습니다.

**A:** 권장하지 않지만, 긴급한 경우:

```bash
git commit --no-verify -m "message"
```

**주의:** CI에서 동일한 검사가 실행되므로 결국 실패할 수 있습니다.

---

### Q: Husky가 작동하지 않습니다.

**A:** Husky를 초기화해야 합니다:

```bash
npm install husky --save-dev
npx husky install
```

또는 `package.json`에 prepare 스크립트 추가:
```json
{
  "scripts": {
    "prepare": "husky install"
  }
}
```

---

## 문서

### Q: ADR은 언제 작성해야 하나요?

**A:** 다음 상황에서 ADR(Architecture Decision Record)을 작성하세요:

- 새로운 기술/프레임워크 도입
- 아키텍처 패턴 선택
- 중요한 설계 결정
- 기존 결정 변경

템플릿: `docs/adr/template.md`

---

### Q: API 문서는 어디에 작성하나요?

**A:** `docs/api/` 디렉토리에 작성합니다. OpenAPI(Swagger) 스펙을 사용하는 것을 권장합니다.

---

## 배포

### Q: 배포 워크플로우는 어떻게 설정하나요?

**A:** `.github/workflows/cd.yml`을 프로젝트에 맞게 수정하세요. 기본적으로 다음 구조를 따릅니다:

```
main 브랜치 푸시 → Staging 자동 배포
릴리스 태그 → Production 배포 (승인 필요)
```

실제 배포 명령어는 인프라에 따라 다릅니다 (AWS, GCP, K8s 등).

---

### Q: 롤백은 어떻게 하나요?

**A:** `.github/workflows/rollback.yml`을 수동으로 트리거하세요:

1. Actions 탭 이동
2. "Rollback" 워크플로우 선택
3. "Run workflow" 클릭
4. 환경, 대상 버전, 사유 입력
5. Production은 승인 필요

---

## 문제 해결

### Q: 템플릿 업데이트는 어떻게 받나요?

**A:** 이 템플릿은 시작점으로 사용되므로, 업데이트를 자동으로 받지 않습니다. 주요 업데이트가 있을 경우 수동으로 반영하세요.

원본 템플릿을 upstream으로 추가하여 변경사항을 확인할 수 있습니다:

```bash
git remote add upstream https://github.com/<template-org>/vibe-project-template.git
git fetch upstream
git diff main upstream/main
```

---

### Q: 특정 파일/디렉토리가 필요 없습니다.

**A:** 자유롭게 삭제하세요. 이 템플릿은 가이드라인이지 강제 사항이 아닙니다.

예를 들어 Roo Code를 사용하지 않는다면 `.roo/` 디렉토리를 삭제해도 됩니다.

---

### Q: 추가 질문이 있습니다.

**A:**
- GitHub Issues에 질문 등록
- GitHub Discussions에서 토론
- 팀 내부 Slack 채널 활용

---

## 참고

- [시작 가이드](./getting-started.md)
- [개발 가이드](./development.md)
- [커스터마이징 가이드](./customization.md)
- [GitHub 설정 체크리스트](./github-setup-checklist.md)
