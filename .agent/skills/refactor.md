# Refactor Skill

> AI 에이전트의 안전한 리팩토링 가이드

## 트리거

```
/refactor
```

## 리팩토링 원칙

### 안전한 리팩토링의 조건

1. **테스트 존재**: 리팩토링 전 충분한 테스트 커버리지 확보
2. **작은 단계**: 한 번에 하나의 변경만 수행
3. **동작 보존**: 외부 동작은 변경하지 않음
4. **지속적 검증**: 각 단계마다 테스트 실행

### 리팩토링 전 체크리스트

```markdown
- [ ] 기존 테스트가 모두 통과하는가?
- [ ] 리팩토링 대상 코드의 테스트 커버리지가 충분한가?
- [ ] 리팩토링 목적이 명확한가?
- [ ] 영향 범위를 파악했는가?
```

## 리팩토링 카탈로그

### 1. 함수 추출 (Extract Function)

**적용 시점**: 코드 블록이 무엇을 하는지 설명이 필요할 때

```typescript
// Before
function printOwing(invoice: Invoice) {
  let outstanding = 0;

  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");

  // calculate outstanding
  for (const order of invoice.orders) {
    outstanding += order.amount;
  }

  // print details
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}

// After
function printOwing(invoice: Invoice) {
  printBanner();
  const outstanding = calculateOutstanding(invoice);
  printDetails(invoice, outstanding);
}

function printBanner() {
  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");
}

function calculateOutstanding(invoice: Invoice): number {
  return invoice.orders.reduce((sum, order) => sum + order.amount, 0);
}

function printDetails(invoice: Invoice, outstanding: number) {
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}
```

### 2. 변수 추출 (Extract Variable)

**적용 시점**: 복잡한 표현식을 이해하기 어려울 때

```typescript
// Before
function price(order: Order): number {
  return order.quantity * order.itemPrice -
    Math.max(0, order.quantity - 500) * order.itemPrice * 0.05 +
    Math.min(order.quantity * order.itemPrice * 0.1, 100);
}

// After
function price(order: Order): number {
  const basePrice = order.quantity * order.itemPrice;
  const quantityDiscount = Math.max(0, order.quantity - 500) * order.itemPrice * 0.05;
  const shipping = Math.min(basePrice * 0.1, 100);
  return basePrice - quantityDiscount + shipping;
}
```

### 3. 함수 인라인 (Inline Function)

**적용 시점**: 함수 본문이 이름만큼 명확할 때

```typescript
// Before
function getRating(driver: Driver): number {
  return moreThanFiveLateDeliveries(driver) ? 2 : 1;
}

function moreThanFiveLateDeliveries(driver: Driver): boolean {
  return driver.numberOfLateDeliveries > 5;
}

// After
function getRating(driver: Driver): number {
  return driver.numberOfLateDeliveries > 5 ? 2 : 1;
}
```

### 4. 조건문 분해 (Decompose Conditional)

**적용 시점**: 복잡한 조건문이 있을 때

```typescript
// Before
function calculateCharge(date: Date, quantity: number): number {
  let charge: number;
  if (date < SUMMER_START || date > SUMMER_END) {
    charge = quantity * winterRate + winterServiceCharge;
  } else {
    charge = quantity * summerRate;
  }
  return charge;
}

// After
function calculateCharge(date: Date, quantity: number): number {
  if (isSummer(date)) {
    return summerCharge(quantity);
  }
  return winterCharge(quantity);
}

function isSummer(date: Date): boolean {
  return date >= SUMMER_START && date <= SUMMER_END;
}

function summerCharge(quantity: number): number {
  return quantity * summerRate;
}

function winterCharge(quantity: number): number {
  return quantity * winterRate + winterServiceCharge;
}
```

### 5. 조건문을 다형성으로 (Replace Conditional with Polymorphism)

**적용 시점**: 타입에 따라 다른 동작을 하는 switch/if 문이 있을 때

```typescript
// Before
function calculatePay(employee: Employee): number {
  switch (employee.type) {
    case 'engineer':
      return employee.monthlySalary;
    case 'salesman':
      return employee.monthlySalary + employee.commission;
    case 'manager':
      return employee.monthlySalary + employee.bonus;
    default:
      throw new Error('Unknown employee type');
  }
}

// After
abstract class Employee {
  constructor(protected monthlySalary: number) {}
  abstract calculatePay(): number;
}

class Engineer extends Employee {
  calculatePay(): number {
    return this.monthlySalary;
  }
}

class Salesman extends Employee {
  constructor(monthlySalary: number, private commission: number) {
    super(monthlySalary);
  }
  calculatePay(): number {
    return this.monthlySalary + this.commission;
  }
}

class Manager extends Employee {
  constructor(monthlySalary: number, private bonus: number) {
    super(monthlySalary);
  }
  calculatePay(): number {
    return this.monthlySalary + this.bonus;
  }
}
```

### 6. 객체를 매개변수로 (Introduce Parameter Object)

**적용 시점**: 여러 매개변수가 함께 전달될 때

```typescript
// Before
function amountInvoiced(startDate: Date, endDate: Date): number { ... }
function amountReceived(startDate: Date, endDate: Date): number { ... }
function amountOverdue(startDate: Date, endDate: Date): number { ... }

// After
class DateRange {
  constructor(
    public readonly start: Date,
    public readonly end: Date
  ) {}
}

function amountInvoiced(range: DateRange): number { ... }
function amountReceived(range: DateRange): number { ... }
function amountOverdue(range: DateRange): number { ... }
```

### 7. 중첩 조건문을 보호절로 (Replace Nested Conditional with Guard Clauses)

**적용 시점**: 깊은 중첩 조건문이 있을 때

```typescript
// Before
function getPayAmount(employee: Employee): number {
  let result: number;
  if (employee.isSeparated) {
    result = separatedAmount();
  } else {
    if (employee.isRetired) {
      result = retiredAmount();
    } else {
      result = normalPayAmount();
    }
  }
  return result;
}

// After
function getPayAmount(employee: Employee): number {
  if (employee.isSeparated) return separatedAmount();
  if (employee.isRetired) return retiredAmount();
  return normalPayAmount();
}
```

## 리팩토링 프로세스

### Step 1: 분석

```markdown
1. 코드 스멜 식별
2. 영향 범위 파악
3. 테스트 커버리지 확인
4. 리팩토링 기법 선택
```

### Step 2: 준비

```markdown
1. 현재 테스트 실행 (모두 통과 확인)
2. 필요시 테스트 추가
3. 버전 관리 커밋 (안전한 롤백 지점)
```

### Step 3: 실행

```markdown
1. 작은 단위로 변경
2. 각 변경 후 테스트 실행
3. 문제 발생 시 즉시 롤백
4. 성공 시 커밋
```

### Step 4: 검증

```markdown
1. 전체 테스트 스위트 실행
2. 코드 리뷰 요청
3. 성능 영향 확인
```

## 코드 스멜 탐지

### 함수 관련

| 스멜 | 증상 | 리팩토링 |
|------|------|----------|
| Long Method | 20줄 이상 | Extract Function |
| Long Parameter List | 3개 이상 매개변수 | Introduce Parameter Object |
| Duplicate Code | 동일 코드 반복 | Extract Function |

### 클래스 관련

| 스멜 | 증상 | 리팩토링 |
|------|------|----------|
| Large Class | 너무 많은 책임 | Extract Class |
| Feature Envy | 다른 클래스 데이터에 과도한 접근 | Move Method |
| Data Clumps | 항상 함께 다니는 데이터 | Extract Class |

### 조건문 관련

| 스멜 | 증상 | 리팩토링 |
|------|------|----------|
| Complex Conditional | 복잡한 if/switch | Decompose Conditional |
| Nested Conditionals | 깊은 중첩 | Guard Clauses |
| Type Code | 타입별 분기 | Polymorphism |

## AI 리팩토링 출력 형식

```markdown
## 리팩토링 제안

### 대상
- **파일**: `src/services/order-service.ts`
- **함수**: `processOrder`
- **라인**: 45-120

### 발견된 코드 스멜
1. **Long Method** (75줄)
2. **Complex Conditional** (5단계 중첩)
3. **Duplicate Code** (3곳에서 동일 패턴)

### 리팩토링 계획

#### Step 1: Extract Function - 검증 로직 분리
```typescript
// Before
// 45-60라인의 검증 로직

// After
function validateOrder(order: Order): ValidationResult { ... }
```

#### Step 2: Decompose Conditional - 할인 계산 분리
```typescript
// Before
// 65-90라인의 중첩 조건문

// After
function calculateDiscount(order: Order): number { ... }
```

### 예상 결과
- 함수 길이: 75줄 → 20줄
- 중첩 깊이: 5 → 2
- 테스트 용이성: 개선

### 주의사항
- `calculateDiscount` 함수에 대한 단위 테스트 필요
- 기존 API 인터페이스 변경 없음
```

## 참고 자료

- [Refactoring Guru](https://refactoring.guru/)
- [Martin Fowler - Refactoring](https://martinfowler.com/books/refactoring.html)
- [프로젝트 컨벤션](../conventions.md)

---

**Note**: 리팩토링은 반드시 테스트와 함께 진행하세요.
테스트 없는 리팩토링은 위험합니다.
