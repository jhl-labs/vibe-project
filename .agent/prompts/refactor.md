# Refactoring Prompt

## 목적
기존 코드의 구조를 개선하면서 동작은 유지합니다.

## 컨텍스트
리팩토링 대상 코드와 개선 목표를 명확히 해야 합니다.

---

## 프롬프트 템플릿

```
다음 코드를 리팩토링해줘.

### 대상 코드
[파일 경로 또는 코드 블록]

### 현재 문제점
- [문제 1: 예 - 함수가 너무 길다]
- [문제 2: 예 - 중복 코드가 있다]
- [문제 3: 예 - 테스트하기 어렵다]

### 리팩토링 목표
- [목표 1: 예 - 함수를 작은 단위로 분리]
- [목표 2: 예 - 중복 제거]
- [목표 3: 예 - 의존성 주입으로 테스트 용이성 확보]

### 제약 조건
- [기존 API 시그니처 유지 필요]
- [성능 저하 없어야 함]
- [다른 파일 변경 최소화]

다음을 제공해줘:
1. 리팩토링 계획
2. 단계별 변경 사항
3. 리팩토링된 코드
4. 검증 방법
```

---

## 출력 형식

```markdown
## 리팩토링 계획

### 분석
[현재 코드의 문제점 분석]

### 적용할 기법
- [리팩토링 패턴 1]
- [리팩토링 패턴 2]

### 단계별 진행

#### Step 1: [단계 이름]
**변경 전:**
\`\`\`
[코드]
\`\`\`

**변경 후:**
\`\`\`
[코드]
\`\`\`

**이유:** [왜 이렇게 변경하는지]

### 최종 코드
[전체 리팩토링된 코드]

### 검증 방법
[동작이 유지되는지 확인하는 방법]
```

---

## 예시

### 입력
```
다음 코드를 리팩토링해줘.

### 대상 코드
src/services/order.service.ts

### 현재 문제점
- processOrder 함수가 200줄이 넘음
- 할인 계산, 재고 확인, 결제 처리가 모두 한 함수에 있음
- 테스트 시 실제 결제 API를 호출함

### 리팩토링 목표
- 단일 책임 원칙 적용
- 테스트 가능한 구조로 변경

### 제약 조건
- processOrder의 입출력 시그니처 유지
```

### 출력
```markdown
## 리팩토링 계획

### 분석
`processOrder` 함수가 다음 책임들을 모두 갖고 있어 SRP를 위반합니다:
1. 주문 유효성 검증
2. 재고 확인 및 차감
3. 할인 계산
4. 결제 처리
5. 주문 저장

### 적용할 기법
- **Extract Method**: 각 책임을 별도 메서드로 분리
- **Dependency Injection**: 외부 서비스(결제, 재고)를 주입받도록 변경
- **Strategy Pattern**: 할인 정책을 전략 패턴으로 분리

### 단계별 진행

#### Step 1: 결제 서비스 인터페이스 추출

**변경 전:**
\`\`\`typescript
class OrderService {
  async processOrder(order: Order) {
    // ... 200줄의 코드
    const result = await paymentApi.charge(amount);
  }
}
\`\`\`

**변경 후:**
\`\`\`typescript
interface PaymentService {
  charge(amount: number): Promise<PaymentResult>;
}

class OrderService {
  constructor(private paymentService: PaymentService) {}
}
\`\`\`

**이유:** 테스트 시 Mock 주입 가능

#### Step 2: 할인 계산 분리

\`\`\`typescript
interface DiscountStrategy {
  calculate(order: Order): number;
}

class PercentageDiscount implements DiscountStrategy {
  constructor(private rate: number) {}
  calculate(order: Order): number {
    return order.total * this.rate;
  }
}
\`\`\`

#### Step 3: 재고 서비스 분리

\`\`\`typescript
interface InventoryService {
  checkAvailability(items: OrderItem[]): Promise<boolean>;
  reserve(items: OrderItem[]): Promise<void>;
}
\`\`\`

### 최종 코드

\`\`\`typescript
class OrderService {
  constructor(
    private paymentService: PaymentService,
    private inventoryService: InventoryService,
    private discountStrategy: DiscountStrategy,
    private orderRepository: OrderRepository
  ) {}

  async processOrder(order: Order): Promise<OrderResult> {
    await this.validateOrder(order);
    await this.reserveInventory(order);
    const finalAmount = this.applyDiscount(order);
    await this.processPayment(finalAmount);
    return this.saveOrder(order);
  }

  private async validateOrder(order: Order): Promise<void> { /* ... */ }
  private async reserveInventory(order: Order): Promise<void> { /* ... */ }
  private applyDiscount(order: Order): number { /* ... */ }
  private async processPayment(amount: number): Promise<void> { /* ... */ }
  private async saveOrder(order: Order): Promise<OrderResult> { /* ... */ }
}
\`\`\`

### 검증 방법
1. 기존 통합 테스트 실행하여 동작 유지 확인
2. 새로 분리된 각 메서드에 대한 단위 테스트 추가
3. Mock 서비스로 에러 케이스 테스트
```

---

## 일반적인 리팩토링 패턴

### Extract Method
긴 함수를 의미 있는 단위로 분리

### Extract Class
하나의 클래스가 너무 많은 책임을 가질 때

### Replace Conditional with Polymorphism
복잡한 조건문을 다형성으로 대체

### Introduce Parameter Object
여러 매개변수를 객체로 그룹화

### Replace Magic Number with Constant
매직 넘버를 명명된 상수로 대체
