# Architecture Decision Records (ADR)

> 아키텍처 결정 기록 보관소

## ADR이란?

ADR(Architecture Decision Record)은 소프트웨어 아키텍처에 관한 중요한 결정을 문서화하는 방법입니다. 각 ADR은 단일 결정과 그 맥락, 결과를 기록합니다.

## 왜 ADR을 사용하나요?

1. **결정의 맥락 보존**: 왜 그런 결정을 했는지 기록
2. **온보딩 지원**: 새 팀원이 프로젝트 이해에 도움
3. **지식 공유**: 팀 전체가 결정 근거를 공유
4. **변경 추적**: 아키텍처 진화 과정 추적

## ADR 작성 가이드

### 언제 작성하나요?

- 새로운 기술/프레임워크 도입 시
- 아키텍처 패턴 선택 시
- 중요한 설계 결정 시
- 기존 결정 변경 시

### ADR 상태

| 상태 | 설명 |
|------|------|
| Proposed | 검토 중인 제안 |
| Accepted | 승인되어 적용 중 |
| Deprecated | 더 이상 유효하지 않음 |
| Superseded | 새로운 ADR로 대체됨 |

### 파일 명명 규칙

```
ADR-XXXX-제목.md

예시:
ADR-0001-use-postgresql-for-primary-database.md
ADR-0002-adopt-microservices-architecture.md
```

## ADR 목록

| ID | 제목 | 상태 | 날짜 |
|----|------|------|------|
| - | 아직 ADR이 없습니다 | - | - |

## 템플릿

새 ADR 작성 시 [template.md](./template.md)를 사용하세요.

## 참고 자료

- [Michael Nygard's ADR](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- [ADR GitHub Organization](https://adr.github.io/)
- [AWS 아키텍처 블로그](https://aws.amazon.com/blogs/architecture/)

---

**Tip**: ADR은 짧고 명확하게 작성하세요. 한 ADR에 하나의 결정만 담습니다.
