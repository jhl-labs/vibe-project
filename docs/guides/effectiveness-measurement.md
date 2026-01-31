# Vibe Coding 효과 측정 가이드

AI Agent 활용의 효과를 측정하고 개선하는 방법을 안내합니다.

## 측정의 목적

1. **ROI 증명**: AI 도구 도입의 투자 대비 효과 입증
2. **개선 영역 식별**: 더 효과적으로 활용할 수 있는 영역 파악
3. **모범 사례 발굴**: 성공적인 활용 패턴 공유
4. **교육 방향 설정**: 팀 교육의 우선순위 결정

## 핵심 지표 (KPIs)

### 1. 생산성 지표

#### 코드 생산량
| 지표 | 측정 방법 | 목표 |
|------|----------|------|
| PR 생성 속도 | PR 생성까지 평균 시간 | 30% 단축 |
| 코드 라인 수 | 일일 커밋 라인 수 | 참고용 (품질과 함께) |
| 기능 완료율 | 스프린트당 완료 스토리 | 20% 향상 |

```bash
# PR 생성 시간 측정 (Git 기반)
git log --format="%H %ai" --first-parent | head -20
```

#### 시간 절약
| 활동 | 기존 시간 | AI 활용 시간 | 절감률 |
|------|----------|-------------|--------|
| 보일러플레이트 작성 | 2시간 | 15분 | 87% |
| 테스트 코드 작성 | 1시간 | 20분 | 67% |
| 문서화 | 3시간 | 30분 | 83% |
| 코드 리뷰 준비 | 30분 | 10분 | 67% |

### 2. 품질 지표

#### 코드 품질
| 지표 | 측정 방법 | 목표 |
|------|----------|------|
| 버그 발생률 | 릴리스당 버그 수 | 20% 감소 |
| 테스트 커버리지 | 코드 커버리지 % | 10% 향상 |
| 코드 리뷰 수정 요청 | PR당 수정 요청 수 | 30% 감소 |
| 기술 부채 | SonarQube 점수 | 유지/개선 |

#### 보안 품질
| 지표 | 측정 방법 |
|------|----------|
| 보안 취약점 | SAST 스캔 결과 |
| 의존성 취약점 | Dependabot 알림 수 |

### 3. 팀 만족도

#### 개발자 경험 (DevEx)
```
설문 항목 (1-5점):
1. AI 도구가 일상 업무에 도움이 되나요?
2. 반복적인 작업이 줄었나요?
3. 새로운 기술/코드베이스 학습에 도움이 되나요?
4. 코드 품질에 대한 자신감이 높아졌나요?
5. AI 도구 없이 작업하고 싶나요? (역점수)
```

#### 채택률
| 지표 | 측정 |
|------|------|
| 일일 활성 사용자 | AI 도구 사용 개발자 수 |
| 기능별 사용률 | 코드 생성 / 리뷰 / 문서화 |
| 세션당 사용 시간 | 평균 사용 시간 |

## 측정 방법

### 자동 측정

#### GitHub Actions 워크플로우

```yaml
# .github/workflows/metrics.yml
name: Development Metrics

on:
  schedule:
    - cron: '0 9 * * 1'  # 매주 월요일

jobs:
  collect-metrics:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Calculate PR metrics
        run: |
          echo "## PR Metrics" >> $GITHUB_STEP_SUMMARY

          # 지난 주 PR 수
          # Linux: date -d, macOS: date -v (또는 brew install coreutils → gdate -d)
          PR_COUNT=$(gh pr list --state merged --search "merged:>=$(date -d '7 days ago' +%Y-%m-%d 2>/dev/null || date -v-7d +%Y-%m-%d)" | wc -l)
          echo "Merged PRs (last 7 days): $PR_COUNT" >> $GITHUB_STEP_SUMMARY

          # 평균 PR 크기
          gh pr list --state merged --limit 10 --json additions,deletions \
            --jq 'map(.additions + .deletions) | add / length' >> $GITHUB_STEP_SUMMARY
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Code quality metrics
        run: |
          # 테스트 커버리지 (예: Jest)
          npm test -- --coverage --coverageReporters=text-summary
```

#### 커밋 메시지 분석

```bash
#!/bin/bash
# scripts/analyze-commits.sh

# AI 지원 커밋 식별 (Co-Authored-By 태그 기반)
AI_COMMITS=$(git log --since="1 week ago" --grep="Co-Authored-By: Claude" | wc -l)
TOTAL_COMMITS=$(git log --since="1 week ago" --oneline | wc -l)

echo "AI-assisted commits: $AI_COMMITS / $TOTAL_COMMITS"
echo "AI assistance rate: $(echo "scale=2; $AI_COMMITS * 100 / $TOTAL_COMMITS" | bc)%"
```

### 수동 측정

#### 주간 회고 템플릿

```markdown
## 주간 AI 활용 회고

### 이번 주 AI 활용 현황
- 사용 빈도: [ ] 매일 [ ] 자주 [ ] 가끔 [ ] 거의 없음
- 주요 활용 영역:
  - [ ] 코드 생성
  - [ ] 버그 수정
  - [ ] 코드 리뷰
  - [ ] 테스트 작성
  - [ ] 문서화
  - [ ] 학습/탐색

### 효과적이었던 활용
[구체적인 사례 작성]

### 개선이 필요한 부분
[어려웠던 점, 기대와 다른 결과]

### 시간 절약 추정
- 예상 절약 시간: ___시간
- 가장 많이 절약한 활동: ___

### 다음 주 개선 계획
[더 잘 활용할 방법]
```

## 대시보드 구성

### Grafana 대시보드 예시

```json
{
  "dashboard": {
    "title": "Vibe Coding Metrics",
    "panels": [
      {
        "title": "Weekly PR Count",
        "type": "stat",
        "targets": [{"expr": "github_pr_merged_total"}]
      },
      {
        "title": "AI-Assisted Commits %",
        "type": "gauge",
        "targets": [{"expr": "ai_assisted_commits / total_commits * 100"}]
      },
      {
        "title": "Test Coverage Trend",
        "type": "timeseries",
        "targets": [{"expr": "code_coverage_percent"}]
      },
      {
        "title": "Bug Rate Trend",
        "type": "timeseries",
        "targets": [{"expr": "bugs_per_release"}]
      }
    ]
  }
}
```

### 간단한 스프레드시트 추적

| 주차 | PR 수 | AI 활용 PR | 평균 리뷰 시간 | 버그 수 | 팀 만족도 |
|------|-------|-----------|--------------|--------|----------|
| W1 | 12 | 4 (33%) | 4시간 | 3 | 3.5 |
| W2 | 15 | 8 (53%) | 3시간 | 2 | 3.8 |
| W3 | 18 | 12 (67%) | 2.5시간 | 1 | 4.0 |

## 벤치마크

### 업계 평균 비교

| 지표 | 업계 평균 | AI 활용 팀 | 개선율 |
|------|----------|-----------|--------|
| 코드 리뷰 시간 | 4시간 | 1.5시간 | 62% |
| 버그 수정 시간 | 2시간 | 45분 | 62% |
| 테스트 커버리지 | 60% | 80% | 33% |
| 문서화 완성도 | 40% | 85% | 112% |

### 도입 전후 비교

```
도입 전 (Baseline):
- 평균 PR 작성 시간: 4시간
- PR당 수정 요청: 3회
- 테스트 커버리지: 55%

도입 후 (3개월):
- 평균 PR 작성 시간: 2시간 (-50%)
- PR당 수정 요청: 1.5회 (-50%)
- 테스트 커버리지: 75% (+36%)
```

## 개선 사이클

### 1. 측정 (Measure)
- 주간/월간 지표 수집
- 팀 설문 조사

### 2. 분석 (Analyze)
- 트렌드 파악
- 병목 지점 식별
- 성공 패턴 발굴

### 3. 개선 (Improve)
- 프롬프트 라이브러리 업데이트
- 팀 교육 실시
- 워크플로우 최적화

### 4. 공유 (Share)
- 성공 사례 문서화
- 팀 간 모범 사례 공유
- 가이드라인 업데이트

## 보고서 템플릿

### 월간 효과 보고서

```markdown
# Vibe Coding 월간 효과 보고서

**기간**: YYYY년 MM월
**작성자**: [이름]

## Executive Summary
[핵심 성과 3줄 요약]

## 주요 지표

### 생산성
| 지표 | 전월 | 금월 | 변화 |
|------|------|------|------|
| 완료 스토리 | 45 | 52 | +16% |
| PR 머지 수 | 60 | 75 | +25% |

### 품질
| 지표 | 전월 | 금월 | 변화 |
|------|------|------|------|
| 버그 발생 | 12 | 8 | -33% |
| 테스트 커버리지 | 72% | 78% | +8% |

### 팀 만족도
- 평균 점수: 4.2/5.0 (전월 대비 +0.3)

## 성공 사례
[이번 달 우수 활용 사례]

## 도전 과제
[어려웠던 점과 대응 방안]

## 다음 달 계획
[개선 계획]
```

## 주의사항

### 측정하지 말아야 할 것

- **순수 라인 수**: 품질 없는 양적 지표
- **개인별 비교**: 경쟁 유발, 협업 저해
- **AI 의존도**: 도구 활용이 아닌 의존은 문제

### 올바른 관점

- 팀 전체의 성과 향상에 집중
- 품질과 생산성의 균형
- 장기적인 트렌드 관찰
- 정성적 피드백의 가치 인정
