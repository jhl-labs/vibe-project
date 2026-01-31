# CLAUDE.md

> Claude Code를 위한 프로젝트 지침서
>
> 이 파일은 Claude가 대화 시작 시 자동으로 컨텍스트에 로드합니다.
> 간결하게 유지하세요 - 모든 줄은 실제 작업과 주의를 경쟁합니다.

## 프로젝트 개요

- **이름**: `<project-name>`
- **설명**: `<프로젝트 목적과 주요 기능>`
- **기술 스택**: `<언어, 프레임워크, DB, 인프라>`

## 빠른 명령어

```bash
# 의존성 설치
<패키지매니저> install

# 개발 서버
<실행 명령어>

# 테스트
<테스트 명령어>

# 빌드
<빌드 명령어>

# 린트
<린트 명령어>
```

## 프로젝트 구조

```
src/
├── domain/           # 비즈니스 로직 (순수, 의존성 없음)
├── application/      # 유스케이스, 서비스
├── infrastructure/   # DB, 외부 API 연동
└── presentation/     # HTTP/API 레이어
```

## 코딩 규칙

### 네이밍
- 파일: `kebab-case.ts` (TS/JS), `snake_case.py` (Python)
- 클래스: `PascalCase`
- 함수/변수: `camelCase` (TS/JS), `snake_case` (Python)
- 상수: `UPPER_SNAKE_CASE`

### 스타일
- 들여쓰기: 2 spaces (TS/JS), 4 spaces (Python, PEP 8)
- 최대 줄 길이: 100자
- 함수 최대 길이: 30줄
- Conventional Commits 사용

### 아키텍처 원칙
- 단일 책임 원칙 (SRP)
- 의존성 역전 (DIP)
- 도메인은 외부 의존성 없음

## 보안 필수 사항

**절대 금지:**
- 하드코딩된 시크릿
- eval() 또는 동적 코드 실행
- 검증 없는 사용자 입력 사용
- SQL 인젝션 가능한 쿼리

**필수:**
- 환경 변수로 설정 관리
- 모든 입력 검증
- 적절한 에러 처리

## AI 작업 지침

### 코드 생성 시
1. 기존 패턴과 스타일 따르기
2. 테스트 코드 함께 작성
3. 에러 처리 포함
4. 새 의존성 추가 전 기존 라이브러리 확인

### 리뷰 시
1. 보안 취약점 우선 확인
2. 에러 처리 검증
3. 성능 이슈 체크
4. 컨벤션 준수 여부

## 환경 변수

```env
# .env.example 참조
DATABASE_URL=
API_KEY=
```

## 참고 문서

- `.agent/context.md` - 상세 프로젝트 컨텍스트
- `.agent/conventions.md` - 코딩 컨벤션 상세
- `docs/adr/` - 아키텍처 결정 기록

---

<!-- Claude Code 팁:
- /init 명령어로 이 파일 자동 생성 가능
- # 키를 눌러 지시사항을 CLAUDE.md에 자동 추가
- CLAUDE.local.md로 개인 설정 분리 (.gitignore에 추가)
- .claude/CLAUDE.md 위치도 지원됨
-->
