# Prompt Library

AI Agent와의 효과적인 협업을 위한 프롬프트 템플릿 모음입니다.

## 목적

이 라이브러리는 다음을 목표로 합니다:
- **일관성**: 팀 전체가 동일한 품질의 프롬프트 사용
- **효율성**: 검증된 프롬프트로 시행착오 감소
- **학습**: 효과적인 프롬프트 작성법 전파

## 프롬프트 카테고리

### 설계 (Design)
- [api-design.md](./api-design.md) - API 엔드포인트 설계
- [database-schema.md](./database-schema.md) - 데이터베이스 스키마 설계
- [architecture-decision.md](./architecture-decision.md) - 아키텍처 결정

### 구현 (Implementation)
- [feature-implement.md](./feature-implement.md) - 신규 기능 구현
- [bug-fix.md](./bug-fix.md) - 버그 수정
- [refactor.md](./refactor.md) - 코드 리팩토링

### 검토 (Review)
- [code-review.md](./code-review.md) - 코드 리뷰
- [security-review.md](./security-review.md) - 보안 검토
- [performance-review.md](./performance-review.md) - 성능 검토

### 마이그레이션 (Migration)
- [migration.md](./migration.md) - 코드/데이터 마이그레이션
- [upgrade-dependency.md](./upgrade-dependency.md) - 의존성 업그레이드

### 문서화 (Documentation)
- [api-docs.md](./api-docs.md) - API 문서 작성
- [readme-gen.md](./readme-gen.md) - README 생성

## 사용 방법

### 1. 직접 참조
```
@.agent/prompts/bug-fix.md 를 참고해서 이 버그를 수정해줘
```

### 2. 복사 & 수정
프롬프트 템플릿을 복사하여 프로젝트 상황에 맞게 수정

### 3. 슬래시 커맨드 연동
```bash
# Claude Code에서
/bug-fix <issue-description>
```

## 프롬프트 구조

각 프롬프트는 다음 구조를 따릅니다:

```markdown
# [프롬프트 이름]

## 목적
이 프롬프트의 사용 목적

## 컨텍스트
필요한 배경 정보

## 지시사항
AI에게 전달할 구체적 지시

## 출력 형식
기대하는 출력 형태

## 예시
실제 사용 예시
```

## 기여 가이드

### 새 프롬프트 추가

1. 적절한 카테고리 선택
2. 템플릿 구조 준수
3. 실제 사용 테스트
4. README에 링크 추가

### 프롬프트 개선

1. 사용 피드백 수집
2. 성공/실패 사례 분석
3. 반복적 개선

## 모범 사례

### Do
- 구체적인 컨텍스트 제공
- 예상 출력 형식 명시
- 단계별 지시사항 작성
- 제약 조건 명확히

### Don't
- 모호한 요청
- 과도한 정보 제공
- 여러 작업 동시 요청
- 출력 형식 미지정
