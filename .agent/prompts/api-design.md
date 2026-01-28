# API Design Prompt

## 목적
RESTful API 엔드포인트를 설계합니다.

## 컨텍스트
프로젝트의 도메인과 기존 API 패턴을 이해한 상태에서 새로운 API를 설계해야 합니다.

---

## 프롬프트 템플릿

```
나는 [리소스명]에 대한 API를 설계해야 해.

### 요구사항
- [비즈니스 요구사항 1]
- [비즈니스 요구사항 2]

### 관련 도메인 엔티티
- [엔티티 1]: [설명]
- [엔티티 2]: [설명]

### 제약 조건
- [보안 요구사항]
- [성능 요구사항]
- [호환성 요구사항]

다음을 포함해서 API를 설계해줘:
1. 엔드포인트 목록 (HTTP method, path, description)
2. Request/Response 스키마
3. 에러 케이스
4. 인증/권한 요구사항
```

---

## 출력 형식

```markdown
## API 설계: [리소스명]

### 엔드포인트

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | /api/v1/resources | 목록 조회 | Required |
| POST | /api/v1/resources | 생성 | Required |

### Request/Response

#### POST /api/v1/resources
**Request:**
\`\`\`json
{
  "field1": "string",
  "field2": 123
}
\`\`\`

**Response (201):**
\`\`\`json
{
  "id": "uuid",
  "field1": "string",
  "created_at": "ISO8601"
}
\`\`\`

### 에러 응답
- 400: 유효성 검증 실패
- 401: 인증 필요
- 403: 권한 없음
- 404: 리소스 없음
```

---

## 예시

### 입력
```
나는 주문(Order)에 대한 API를 설계해야 해.

### 요구사항
- 고객이 주문을 생성할 수 있어야 함
- 주문 상태를 조회할 수 있어야 함
- 관리자가 주문 상태를 변경할 수 있어야 함
- 주문 취소가 가능해야 함

### 관련 도메인 엔티티
- Order: 주문 정보 (id, customer_id, items, status, total)
- OrderItem: 주문 항목 (product_id, quantity, price)
- OrderStatus: pending, confirmed, shipped, delivered, cancelled

### 제약 조건
- 배송 완료된 주문은 취소 불가
- 주문 생성 시 재고 확인 필요
```

### 출력
```markdown
## API 설계: Order

### 엔드포인트

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| POST | /api/v1/orders | 주문 생성 | Customer |
| GET | /api/v1/orders | 내 주문 목록 | Customer |
| GET | /api/v1/orders/:id | 주문 상세 | Customer/Admin |
| PATCH | /api/v1/orders/:id/status | 상태 변경 | Admin |
| POST | /api/v1/orders/:id/cancel | 주문 취소 | Customer |

### POST /api/v1/orders
**Request:**
\`\`\`json
{
  "items": [
    { "product_id": "prod-123", "quantity": 2 }
  ],
  "shipping_address": {
    "street": "...",
    "city": "...",
    "zip": "..."
  }
}
\`\`\`

**Response (201):**
\`\`\`json
{
  "id": "order-456",
  "status": "pending",
  "items": [...],
  "total": 50000,
  "created_at": "2024-01-15T10:30:00Z"
}
\`\`\`
```

---

## 체크리스트

설계 완료 후 확인:
- [ ] RESTful 원칙 준수
- [ ] 일관된 명명 규칙
- [ ] 적절한 HTTP 상태 코드
- [ ] 페이지네이션 고려 (목록 API)
- [ ] 필터링/정렬 옵션
- [ ] 버전 관리 (/v1/)
- [ ] 인증/권한 명세
- [ ] 에러 응답 형식 통일
