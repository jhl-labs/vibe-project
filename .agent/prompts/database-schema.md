# Database Schema Design Prompt

## 목적
데이터베이스 스키마를 설계하거나 수정합니다.

## 컨텍스트
도메인 요구사항과 데이터 관계를 이해해야 합니다.

---

## 프롬프트 템플릿

```
데이터베이스 스키마를 설계해줘.

### 도메인 설명
[비즈니스 도메인과 주요 엔티티 설명]

### 주요 엔티티
- [엔티티 1]: [설명]
- [엔티티 2]: [설명]

### 관계
- [엔티티 A] -- [관계 유형] -- [엔티티 B]

### 요구사항
- [데이터 요구사항 1]
- [데이터 요구사항 2]

### 제약 조건
- [데이터베이스 종류: PostgreSQL/MySQL 등]
- [성능 요구사항]
- [확장성 고려사항]

다음을 제공해줘:
1. ERD (텍스트 형식)
2. 테이블 정의 (DDL)
3. 인덱스 전략
4. 마이그레이션 고려사항
```

---

## 출력 형식

```markdown
## 데이터베이스 스키마 설계

### ERD
\`\`\`
[엔티티 관계도 ASCII 또는 Mermaid]
\`\`\`

### 테이블 정의

#### [테이블명]
| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| ... | ... | ... | ... |

### DDL
\`\`\`sql
CREATE TABLE ...
\`\`\`

### 인덱스 전략
[인덱스 설명 및 DDL]

### 마이그레이션 고려사항
[기존 데이터 처리 방안]
```

---

## 예시

### 입력
```
데이터베이스 스키마를 설계해줘.

### 도메인 설명
이커머스 주문 시스템

### 주요 엔티티
- User: 고객 정보
- Product: 상품 정보
- Order: 주문
- OrderItem: 주문 항목

### 관계
- User 1:N Order (한 사용자가 여러 주문)
- Order 1:N OrderItem (한 주문에 여러 상품)
- Product 1:N OrderItem

### 요구사항
- 주문 이력 조회가 빈번함
- 상품별 판매량 집계 필요
- 소프트 삭제 필요

### 제약 조건
- PostgreSQL 15
- 향후 샤딩 가능성 고려
```

### 출력
```markdown
## 데이터베이스 스키마 설계

### ERD
\`\`\`mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : "ordered in"

    USER {
        uuid id PK
        string email UK
        string name
        timestamp created_at
        timestamp deleted_at
    }

    ORDER {
        uuid id PK
        uuid user_id FK
        string status
        decimal total_amount
        timestamp created_at
    }

    ORDER_ITEM {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        int quantity
        decimal unit_price
    }

    PRODUCT {
        uuid id PK
        string name
        decimal price
        int stock
        timestamp deleted_at
    }
\`\`\`

### 테이블 정의

#### users
| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| id | UUID | PK, DEFAULT uuid_generate_v4() | 사용자 ID |
| email | VARCHAR(255) | UNIQUE, NOT NULL | 이메일 |
| name | VARCHAR(100) | NOT NULL | 이름 |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | 생성일 |
| deleted_at | TIMESTAMPTZ | NULL | 삭제일 (soft delete) |

#### orders
| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|----------|------|
| id | UUID | PK | 주문 ID |
| user_id | UUID | FK(users.id), NOT NULL | 주문자 |
| status | VARCHAR(20) | NOT NULL | 상태 |
| total_amount | DECIMAL(12,2) | NOT NULL | 총 금액 |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | 주문일 |

### DDL

\`\`\`sql
-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    CONSTRAINT uk_users_email UNIQUE (email)
);

-- Products
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    price DECIMAL(12, 2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(12, 2) NOT NULL CHECK (total_amount >= 0),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT chk_order_status CHECK (
        status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')
    )
);

-- Order Items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12, 2) NOT NULL CHECK (unit_price >= 0)
);
\`\`\`

### 인덱스 전략

\`\`\`sql
-- 주문 이력 조회 (사용자별 + 날짜순)
CREATE INDEX idx_orders_user_created
ON orders(user_id, created_at DESC);

-- 주문 상태별 조회
CREATE INDEX idx_orders_status
ON orders(status) WHERE status NOT IN ('delivered', 'cancelled');

-- 상품별 판매량 집계
CREATE INDEX idx_order_items_product
ON order_items(product_id);

-- Soft delete 필터링
CREATE INDEX idx_users_active
ON users(id) WHERE deleted_at IS NULL;

CREATE INDEX idx_products_active
ON products(id) WHERE deleted_at IS NULL;
\`\`\`

### 샤딩 고려사항

향후 샤딩을 위해:
1. **샤딩 키**: `user_id` 사용 권장
2. **조인 최소화**: 주문 조회 시 user 정보는 별도 쿼리
3. **글로벌 테이블**: `products`는 모든 샤드에 복제

### 마이그레이션 고려사항

1. 대용량 테이블 마이그레이션 시 `pg_dump --jobs` 사용
2. 외래 키 제약은 데이터 로드 후 추가
3. 인덱스는 데이터 로드 후 생성
```

---

## 체크리스트

설계 완료 후 확인:
- [ ] 정규화 수준 적절성
- [ ] 인덱스 전략
- [ ] 제약 조건 정의
- [ ] Soft delete 정책
- [ ] 타임스탬프 (created_at, updated_at)
- [ ] NULL 허용 정책
- [ ] 데이터 타입 최적화
- [ ] 명명 규칙 일관성
