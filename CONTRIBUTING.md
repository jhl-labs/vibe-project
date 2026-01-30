# Contributing Guide

> 프로젝트 기여 가이드

이 프로젝트에 관심을 가져주셔서 감사합니다! 기여를 환영합니다.

## 행동 강령 (Code of Conduct)

모든 기여자는 서로를 존중하고 건설적인 의사소통을 해야 합니다.

- 다양한 관점과 경험을 존중합니다
- 건설적인 피드백을 제공합니다
- 커뮤니티에 최선인 것에 집중합니다
- 다른 커뮤니티 구성원에 대해 공감합니다

## 기여 방법

### 버그 리포트

버그를 발견하셨나요?

1. [기존 이슈](https://github.com/<your-org>/<your-project>/issues)에서 동일한 버그가 보고되었는지 확인합니다
2. 새 이슈가 필요하면 [버그 리포트 템플릿](https://github.com/<your-org>/<your-project>/issues/new?template=bug_report.yml)을 사용합니다
3. 가능한 자세히 작성합니다:
   - 재현 방법
   - 예상 동작
   - 실제 동작
   - 환경 정보

### 기능 제안

새 기능을 제안하고 싶으신가요?

1. [기존 제안](https://github.com/<your-org>/<your-project>/issues?q=is%3Aissue+label%3Aenhancement)을 확인합니다
2. [기능 요청 템플릿](https://github.com/<your-org>/<your-project>/issues/new?template=feature_request.yml)을 사용합니다
3. 제안 배경과 사용 사례를 설명합니다

### 코드 기여

#### 1. 환경 설정

```bash
# 저장소 포크
# GitHub에서 Fork 버튼 클릭

# 포크한 저장소 클론
git clone https://github.com/<your-username>/<your-project>.git
cd <your-project>

# 업스트림 추가
git remote add upstream https://github.com/<your-org>/<your-project>.git

# 의존성 설치 (프로젝트에 맞는 명령어 사용)
# npm install          # Node.js
# pip install -r requirements.txt  # Python
# go mod download      # Go
```

#### 2. 브랜치 생성

```bash
# 최신 코드 동기화
git fetch upstream
git checkout main
git merge upstream/main

# 새 브랜치 생성
git checkout -b feature/your-feature-name
# 또는
git checkout -b fix/your-bug-fix
```

#### 3. 개발

개발 시 다음 사항을 준수합니다:

- [코딩 컨벤션](docs/guides/development.md) 준수
- 테스트 코드 작성
- 문서 업데이트 (필요시)

```bash
# 개발 서버 실행 (프로젝트에 맞게 선택)
# npm run dev                    # Node.js
# uvicorn app.main:app --reload  # Python (FastAPI)

# 린트 확인
# npm run lint       # Node.js
# ruff check .       # Python

# 테스트 실행
# npm test           # Node.js
# pytest             # Python

# 타입 체크
# npm run type-check # Node.js (TypeScript)
# mypy .             # Python
```

#### 4. 커밋

[Conventional Commits](https://www.conventionalcommits.org/) 형식을 사용합니다:

```bash
# 커밋 예시
git commit -m "feat(auth): add password reset functionality"
git commit -m "fix(login): resolve redirect issue after login"
git commit -m "docs: update API documentation"
```

**커밋 타입:**

| 타입 | 설명 |
|------|------|
| feat | 새로운 기능 |
| fix | 버그 수정 |
| docs | 문서 변경 |
| style | 코드 포맷팅 |
| refactor | 리팩토링 |
| test | 테스트 추가/수정 |
| chore | 빌드/설정 변경 |

#### 5. Pull Request

```bash
# 변경 사항 푸시
git push origin feature/your-feature-name
```

GitHub에서 Pull Request를 생성합니다:

1. PR 템플릿을 작성합니다
2. 관련 이슈를 링크합니다 (예: `Closes #123`)
3. 리뷰어를 지정합니다

**PR 체크리스트:**

- [ ] 자체 코드 리뷰 완료
- [ ] 테스트 추가/통과
- [ ] 문서 업데이트
- [ ] 커밋 메시지 규칙 준수
- [ ] CI 통과

### 문서 기여

문서 개선도 중요한 기여입니다:

- 오타/문법 수정
- 설명 개선
- 예제 추가
- 번역

## 개발 가이드라인

### 코드 스타일

- [EditorConfig](.editorconfig) 설정을 따릅니다
- ESLint/Prettier 규칙을 준수합니다
- 의미 있는 변수/함수명을 사용합니다

### 테스트

- 새 기능에는 테스트를 추가합니다
- 버그 수정 시 회귀 테스트를 추가합니다
- 테스트 커버리지를 유지합니다

### 문서화

- 공개 API에는 JSDoc/docstring을 추가합니다
- 복잡한 로직에는 주석을 추가합니다
- README와 관련 문서를 업데이트합니다

## 리뷰 프로세스

1. **자동 검사**: CI가 린트, 테스트, 빌드를 확인합니다
2. **코드 리뷰**: 최소 1명의 리뷰어 승인이 필요합니다
3. **수정 요청**: 피드백에 따라 수정합니다
4. **승인 & 머지**: 모든 검사 통과 후 머지됩니다

### 리뷰 기준

- 기능: 요구사항을 충족하는가?
- 설계: 아키텍처 원칙을 따르는가?
- 가독성: 이해하기 쉬운가?
- 테스트: 적절한 테스트가 있는가?
- 보안: 보안 취약점이 없는가?

## 첫 기여자를 위한 안내

처음 기여하시나요? `good first issue` 라벨이 붙은 이슈부터 시작해보세요:

[Good First Issues](https://github.com/<your-org>/<your-project>/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

질문이 있으시면 이슈나 Discussion에서 편하게 물어보세요!

## 연락처

- GitHub Issues: 버그 리포트, 기능 제안
- GitHub Discussions: 일반 질문, 아이디어 논의
- Email: `<maintainer-email>`

## 라이선스

이 프로젝트에 기여하면 [MIT 라이선스](LICENSE)에 동의하는 것으로 간주됩니다.

---

다시 한번 기여에 감사드립니다! 🙏
