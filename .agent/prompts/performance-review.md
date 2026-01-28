# Performance Review Prompt

## 목적
코드의 성능 문제를 분석하고 최적화 방안을 제시합니다.

## 컨텍스트
성능 이슈가 발생한 코드와 측정 데이터를 기반으로 분석합니다.

---

## 프롬프트 템플릿

```
성능 검토를 해줘.

### 검토 대상
[파일 경로 또는 코드]

### 현재 성능 지표
- 응답 시간: [현재 값]
- 목표: [목표 값]
- 처리량: [현재 TPS/RPS]

### 성능 문제 증상
[어떤 상황에서 성능 문제가 발생하는지]

### 환경 정보
- [서버 스펙]
- [데이터베이스 종류/버전]
- [동시 사용자 수]

### 프로파일링 데이터 (있는 경우)
[프로파일링 결과 또는 APM 데이터]

다음을 제공해줘:
1. 병목 지점 분석
2. 최적화 방안
3. 예상 개선 효과
4. 구현 우선순위
```

---

## 출력 형식

```markdown
## 성능 분석 결과

### 요약
[전체적인 성능 상태 평가]

### 병목 지점

#### 1. [병목 위치]
**영향도:** High/Medium/Low
**원인:** [상세 원인]
**증거:** [프로파일링 데이터 또는 코드 분석]

### 최적화 방안

| 우선순위 | 최적화 항목 | 예상 개선 | 난이도 |
|----------|-------------|-----------|--------|
| 1 | ... | ... | ... |

### 상세 권장 사항

#### [최적화 1]
**현재:**
\`\`\`
[현재 코드]
\`\`\`

**개선:**
\`\`\`
[개선 코드]
\`\`\`

**예상 효과:** [정량적 개선 예측]
```

---

## 예시

### 입력
```
성능 검토를 해줘.

### 검토 대상
src/services/product.service.ts - 상품 목록 조회

### 현재 성능 지표
- 응답 시간: 평균 3.2초, P99 8초
- 목표: 평균 500ms 이하
- 처리량: 50 RPS

### 성능 문제 증상
- 상품 수가 10,000개 이상일 때 급격히 느려짐
- 페이지네이션 적용했으나 개선 미미
- 메모리 사용량도 급증

### 환경 정보
- EC2 t3.medium (2 vCPU, 4GB RAM)
- PostgreSQL 14 (RDS db.t3.medium)
- 동시 접속: 약 200명
```

### 출력
```markdown
## 성능 분석 결과

### 요약
N+1 쿼리 문제와 불필요한 데이터 로딩이 주요 병목입니다.
페이지네이션이 적용되었으나 관계 데이터 조회에서 N+1이 발생합니다.

### 병목 지점

#### 1. N+1 쿼리 - 카테고리 조회
**영향도:** High
**원인:** 상품마다 개별 카테고리 조회 쿼리 실행

**현재 쿼리 패턴:**
\`\`\`sql
SELECT * FROM products LIMIT 20;
-- 이후 각 상품마다:
SELECT * FROM categories WHERE id = ?; -- 20회 반복
\`\`\`

**증거:** 20개 상품 조회 시 21개 쿼리 실행 (로그 확인)

---

#### 2. 불필요한 컬럼 로딩
**영향도:** Medium
**원인:** 목록에 불필요한 description(TEXT) 컬럼 포함

**증거:**
- description 평균 크기: 5KB
- 20개 상품 × 5KB = 100KB 불필요 전송

---

#### 3. 인덱스 미사용
**영향도:** Medium
**원인:** 정렬 컬럼에 인덱스 없음

**현재 쿼리:**
\`\`\`sql
SELECT * FROM products ORDER BY created_at DESC LIMIT 20;
-- Seq Scan on products (cost=1234.56)
\`\`\`

---

### 최적화 방안

| 우선순위 | 최적화 항목 | 예상 개선 | 난이도 |
|----------|-------------|-----------|--------|
| 1 | N+1 해결 (JOIN/Eager Loading) | 60% | 낮음 |
| 2 | SELECT 컬럼 제한 | 20% | 낮음 |
| 3 | 인덱스 추가 | 15% | 낮음 |
| 4 | 캐싱 적용 | 추가 30% | 중간 |

### 상세 권장 사항

#### 1. N+1 쿼리 해결

**현재:**
\`\`\`typescript
async getProducts(page: number) {
  const products = await this.productRepo.find({
    skip: (page - 1) * 20,
    take: 20,
  });

  // N+1 발생
  return Promise.all(
    products.map(async (p) => ({
      ...p,
      category: await this.categoryRepo.findById(p.categoryId),
    }))
  );
}
\`\`\`

**개선:**
\`\`\`typescript
async getProducts(page: number) {
  return this.productRepo.find({
    relations: ['category'], // JOIN으로 한 번에 로드
    skip: (page - 1) * 20,
    take: 20,
  });
}
\`\`\`

**예상 효과:** 쿼리 수 21 → 1, 응답 시간 60% 감소

---

#### 2. SELECT 컬럼 제한

**현재:**
\`\`\`typescript
// 모든 컬럼 조회
SELECT * FROM products
\`\`\`

**개선:**
\`\`\`typescript
async getProducts(page: number) {
  return this.productRepo.find({
    select: ['id', 'name', 'price', 'thumbnail', 'categoryId'],
    relations: ['category'],
    skip: (page - 1) * 20,
    take: 20,
  });
}
\`\`\`

**예상 효과:** 응답 크기 80% 감소, 메모리 사용량 개선

---

#### 3. 인덱스 추가

\`\`\`sql
CREATE INDEX idx_products_created_at
ON products(created_at DESC);

-- 복합 인덱스 (카테고리 필터링 시)
CREATE INDEX idx_products_category_created
ON products(category_id, created_at DESC);
\`\`\`

**예상 효과:** Seq Scan → Index Scan, 정렬 성능 개선

---

#### 4. 캐싱 적용 (추가 최적화)

\`\`\`typescript
async getProducts(page: number) {
  const cacheKey = \`products:page:\${page}\`;
  const cached = await this.cache.get(cacheKey);
  if (cached) return cached;

  const products = await this.fetchProducts(page);
  await this.cache.set(cacheKey, products, 60); // 60초 TTL
  return products;
}
\`\`\`

### 예상 최종 결과

| 지표 | 현재 | 최적화 후 |
|------|------|-----------|
| 응답 시간 (평균) | 3.2초 | ~300ms |
| 응답 시간 (P99) | 8초 | ~800ms |
| 쿼리 수 | 21 | 1-2 |
| 응답 크기 | ~100KB | ~20KB |
```

---

## 체크리스트

### 데이터베이스
- [ ] N+1 쿼리 확인
- [ ] 인덱스 사용 여부 (EXPLAIN)
- [ ] 불필요한 컬럼 조회
- [ ] 적절한 페이지네이션

### 애플리케이션
- [ ] 메모리 누수
- [ ] 동기/비동기 처리
- [ ] 캐싱 가능 여부
- [ ] 직렬화/역직렬화 비용

### 네트워크
- [ ] 응답 크기 최적화
- [ ] 압축 적용
- [ ] 연결 풀링
