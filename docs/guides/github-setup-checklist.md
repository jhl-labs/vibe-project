# GitHub Repository 설정 체크리스트

> 템플릿 사용 후 GitHub Repository 설정 가이드

## 개요

이 체크리스트는 템플릿으로 새 저장소를 생성한 후 수동으로 설정해야 하는 GitHub 항목들을 안내합니다.

---

## 1. Repository 기본 설정

### General Settings

**Settings > General**

- [ ] **Repository name**: 프로젝트에 맞게 변경
- [ ] **Description**: 프로젝트 설명 추가
- [ ] **Website**: 프로젝트 URL (있는 경우)
- [ ] **Topics**: 관련 태그 추가 (예: `typescript`, `api`, `microservice`)

### Features

- [ ] **Wikis**: 필요에 따라 활성화/비활성화
- [ ] **Issues**: ✅ 활성화 (기본)
- [ ] **Discussions**: 커뮤니티 소통용 활성화 권장
- [ ] **Projects**: 프로젝트 관리용 활성화 권장

---

## 2. Branch Protection Rules

**Settings > Branches > Add branch protection rule**

### `main` 브랜치 보호

```
Branch name pattern: main
```

#### 필수 설정

- [x] **Require a pull request before merging**
  - [x] Require approvals: `2` (또는 팀 규모에 맞게)
  - [x] Dismiss stale pull request approvals when new commits are pushed
  - [x] Require review from Code Owners

- [x] **Require status checks to pass before merging**
  - [x] Require branches to be up to date before merging
  - Status checks:
    - [ ] `CI / Lint & Format`
    - [ ] `CI / Build`
    - [ ] `CI / Test`
    - [ ] `Security Scan / Code Security Scan`

- [x] **Require conversation resolution before merging**

#### 권장 설정

- [ ] **Require signed commits** (GPG 서명)
- [x] **Do not allow bypassing the above settings**
- [x] **Restrict who can push to matching branches**
  - 관리자만 또는 특정 팀만

### `develop` 브랜치 보호 (사용하는 경우)

```
Branch name pattern: develop
```

- [x] Require a pull request before merging
  - Require approvals: `1`
- [x] Require status checks to pass before merging

---

## 3. Secrets 설정

**Settings > Secrets and variables > Actions**

### 필수 Secrets

| Secret Name | 용도 | 획득 방법 |
|-------------|------|----------|
| `ANTHROPIC_API_KEY` | Claude API 호출 | [Anthropic Console](https://console.anthropic.com/) |

### 선택적 Secrets

| Secret Name | 용도 | 필요 시점 |
|-------------|------|----------|
| `CODECOV_TOKEN` | 코드 커버리지 리포트 | Codecov 연동 시 |
| `SONAR_TOKEN` | SonarCloud 분석 | SonarCloud 연동 시 |
| `SNYK_TOKEN` | 보안 취약점 스캔 | Snyk 연동 시 |
| `SLACK_WEBHOOK_URL` | Slack 알림 | Slack 알림 필요 시 |
| `NPM_TOKEN` | npm 패키지 배포 | npm 배포 시 |
| `AWS_ACCESS_KEY_ID` | AWS 배포 | AWS 사용 시 |
| `AWS_SECRET_ACCESS_KEY` | AWS 배포 | AWS 사용 시 |

### Secrets 추가 방법

1. Settings > Secrets and variables > Actions
2. "New repository secret" 클릭
3. Name과 Secret 입력
4. "Add secret" 클릭

---

## 4. Environments 설정

**Settings > Environments**

### Staging 환경

```
Environment name: staging
```

- [ ] **Wait timer**: 0 minutes (즉시 배포)
- [ ] **Required reviewers**: 비활성화 (자동 배포)

### Production 환경

```
Environment name: production
```

- [x] **Required reviewers**: 활성화
  - 리뷰어 추가 (최소 1명)
- [ ] **Wait timer**: 5 minutes (선택적)
- [x] **Deployment branches**: Selected branches
  - `main` 브랜치만 허용

### Production Rollback Approval 환경

```
Environment name: production-rollback-approval
```

- [x] **Required reviewers**: 활성화 (보안팀/운영팀)

---

## 5. GitHub Actions 설정

**Settings > Actions > General**

### Actions permissions

- [x] **Allow all actions and reusable workflows**
  또는
- [ ] **Allow select actions and reusable workflows** (보안 강화)

### Workflow permissions

- [x] **Read and write permissions**
- [x] **Allow GitHub Actions to create and approve pull requests**

### Fork pull request workflows

- [ ] **Require approval for first-time contributors**
- [ ] **Require approval for all outside collaborators**

---

## 6. Collaborators & Teams

**Settings > Collaborators and teams**

### Teams 추가 (Organization의 경우)

| Team | Role | 책임 |
|------|------|------|
| `@org/maintainers` | Admin | 전체 관리 |
| `@org/developers` | Write | 개발 |
| `@org/security-team` | Write | 보안 리뷰 |
| `@org/devops` | Write | CI/CD, 인프라 |

### CODEOWNERS 검증

`.github/CODEOWNERS` 파일의 팀/사용자가 실제로 존재하고 권한이 있는지 확인:

```
* @org/maintainers
.github/workflows/ @org/devops
```

---

## 7. Security 설정

**Settings > Security**

### Code security and analysis

- [x] **Dependency graph**: 활성화
- [x] **Dependabot alerts**: 활성화
- [x] **Dependabot security updates**: 활성화
- [x] **Dependabot version updates**: 활성화 (dependabot.yml 사용)
- [x] **Code scanning**: 활성화 (security-scan.yml 사용)
- [x] **Secret scanning**: 활성화
- [x] **Push protection**: 활성화 (시크릿 푸시 차단)

### Security policy

`SECURITY.md` 파일이 있으면 자동으로 표시됩니다.

### Security advisories

보안 취약점 비공개 보고를 위해 활성화:
- [x] **Private vulnerability reporting**: 활성화

---

## 8. Webhooks (선택)

**Settings > Webhooks**

필요한 경우 외부 서비스 연동:

| 서비스 | 용도 |
|--------|------|
| Slack | 알림 |
| Discord | 알림 |
| Jira | 이슈 연동 |
| Jenkins | CI/CD 트리거 |

---

## 9. Labels 설정

**Issues > Labels**

다음 라벨이 있는지 확인하고 없으면 추가:

### 유형

| Label | Color | Description |
|-------|-------|-------------|
| `bug` | `#d73a4a` | Something isn't working |
| `enhancement` | `#a2eeef` | New feature or request |
| `documentation` | `#0075ca` | Documentation improvements |
| `question` | `#d876e3` | Further information requested |

### 우선순위

| Label | Color | Description |
|-------|-------|-------------|
| `priority: critical` | `#b60205` | Critical priority |
| `priority: high` | `#d93f0b` | High priority |
| `priority: medium` | `#fbca04` | Medium priority |
| `priority: low` | `#0e8a16` | Low priority |

### 상태

| Label | Color | Description |
|-------|-------|-------------|
| `triage` | `#ededed` | Needs triage |
| `in-progress` | `#0052cc` | Currently being worked on |
| `blocked` | `#b60205` | Blocked by another issue |

### 기타

| Label | Color | Description |
|-------|-------|-------------|
| `good first issue` | `#7057ff` | Good for newcomers |
| `help wanted` | `#008672` | Extra attention needed |
| `security` | `#ee0701` | Security related |
| `ai-generated` | `#1d76db` | Created with AI assistance |

---

## 10. Projects (선택)

**Projects > New project**

팀의 작업 관리를 위해 GitHub Projects 생성:

1. "New project" 클릭
2. 템플릿 선택 (Board, Table, Roadmap)
3. 프로젝트 이름 설정
4. Views 커스터마이징

---

## 최종 확인

### 설정 완료 체크리스트

- [ ] Repository 기본 정보 설정
- [ ] Branch protection rules 설정 (main, develop)
- [ ] 필수 Secrets 추가 (ANTHROPIC_API_KEY)
- [ ] Environments 설정 (staging, production)
- [ ] GitHub Actions 권한 설정
- [ ] 팀/협업자 추가 및 CODEOWNERS 검증
- [ ] Security 기능 활성화
- [ ] Labels 설정

### 테스트

설정 완료 후 다음을 테스트하세요:

1. [ ] 새 브랜치 생성 및 PR 생성
2. [ ] CI 워크플로우 실행 확인
3. [ ] Branch protection 작동 확인
4. [ ] CODEOWNERS 리뷰어 자동 할당 확인
5. [ ] Dependabot 알림 확인

---

## 참고

- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [커스터마이징 가이드](./customization.md)
