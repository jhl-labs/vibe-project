# Test Generation Skill

> AI 에이전트의 테스트 코드 생성 가이드

## 테스트 원칙

### 테스트 피라미드

```
        ╱╲
       ╱  ╲         E2E Tests (10%)
      ╱────╲        - 주요 사용자 플로우
     ╱      ╲
    ╱────────╲      Integration Tests (20%)
   ╱          ╲     - API 엔드포인트, DB 연동
  ╱────────────╲
 ╱              ╲   Unit Tests (70%)
╱────────────────╲  - 비즈니스 로직, 유틸리티
```

### FIRST 원칙

- **F**ast: 빠르게 실행
- **I**ndependent: 독립적으로 실행 가능
- **R**epeatable: 반복 실행해도 동일 결과
- **S**elf-validating: 자동으로 성공/실패 판단
- **T**imely: 적시에 작성 (TDD 권장)

## 테스트 구조

### AAA 패턴

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      // Arrange - 테스트 준비
      const userData = {
        email: 'test@example.com',
        name: 'Test User',
      };
      const mockRepository = createMockUserRepository();

      // Act - 테스트 실행
      const result = await userService.createUser(userData);

      // Assert - 결과 검증
      expect(result.email).toBe(userData.email);
      expect(result.name).toBe(userData.name);
      expect(mockRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(userData)
      );
    });
  });
});
```

### Given-When-Then 패턴 (BDD)

```typescript
describe('Order', () => {
  describe('when calculating total', () => {
    it('should apply discount for orders over $100', () => {
      // Given
      const order = new Order();
      order.addItem({ price: 50, quantity: 3 }); // $150

      // When
      const total = order.calculateTotal();

      // Then
      expect(total).toBe(135); // 10% discount
    });
  });
});
```

## 네이밍 규칙

### 테스트 파일명

```
# TypeScript/JavaScript
user-service.test.ts
user-service.spec.ts

# Python
test_user_service.py
user_service_test.py

# Go
user_service_test.go
```

### 테스트 케이스명

```typescript
// Pattern: should_[expected]_when_[condition]
it('should throw ValidationError when email is invalid')
it('should return null when user not found')
it('should send welcome email when user is created')

// Pattern: [action]_[expected]_[condition]
it('creates user successfully with valid data')
it('throws error for duplicate email')
```

## 단위 테스트 가이드

### 순수 함수 테스트

```typescript
describe('calculateDiscount', () => {
  it('should return 0 for orders under $50', () => {
    expect(calculateDiscount(49)).toBe(0);
  });

  it('should return 5% for orders between $50-$100', () => {
    expect(calculateDiscount(75)).toBe(3.75);
  });

  it('should return 10% for orders over $100', () => {
    expect(calculateDiscount(150)).toBe(15);
  });

  // Edge cases
  it('should handle zero amount', () => {
    expect(calculateDiscount(0)).toBe(0);
  });

  it('should handle negative amount', () => {
    expect(() => calculateDiscount(-10)).toThrow('Invalid amount');
  });
});
```

### 클래스/객체 테스트

```typescript
describe('User', () => {
  describe('constructor', () => {
    it('should create user with valid data', () => {
      const user = new User({
        email: 'test@example.com',
        name: 'Test',
      });

      expect(user.email).toBe('test@example.com');
      expect(user.status).toBe('pending');
    });

    it('should throw for invalid email', () => {
      expect(() => new User({ email: 'invalid', name: 'Test' }))
        .toThrow(ValidationError);
    });
  });

  describe('activate', () => {
    it('should change status from pending to active', () => {
      const user = new User({ email: 'test@example.com', name: 'Test' });

      user.activate();

      expect(user.status).toBe('active');
    });

    it('should throw when already active', () => {
      const user = new User({ email: 'test@example.com', name: 'Test' });
      user.activate();

      expect(() => user.activate())
        .toThrow('User is already active');
    });
  });
});
```

### 비동기 코드 테스트

```typescript
describe('UserService', () => {
  describe('fetchUser', () => {
    it('should return user when found', async () => {
      const mockApi = {
        get: jest.fn().mockResolvedValue({ id: '1', name: 'Test' }),
      };
      const service = new UserService(mockApi);

      const user = await service.fetchUser('1');

      expect(user).toEqual({ id: '1', name: 'Test' });
      expect(mockApi.get).toHaveBeenCalledWith('/users/1');
    });

    it('should throw when API fails', async () => {
      const mockApi = {
        get: jest.fn().mockRejectedValue(new Error('Network error')),
      };
      const service = new UserService(mockApi);

      await expect(service.fetchUser('1'))
        .rejects.toThrow('Network error');
    });
  });
});
```

## 모킹 가이드

### 의존성 모킹

```typescript
// Repository mock
const mockUserRepository: jest.Mocked<IUserRepository> = {
  findById: jest.fn(),
  save: jest.fn(),
  delete: jest.fn(),
};

// Setup mock behavior
mockUserRepository.findById.mockResolvedValue({
  id: '1',
  email: 'test@example.com',
});

// Verify calls
expect(mockUserRepository.save).toHaveBeenCalledWith(
  expect.objectContaining({ email: 'test@example.com' })
);
expect(mockUserRepository.save).toHaveBeenCalledTimes(1);
```

### 외부 서비스 모킹

```typescript
// API client mock
jest.mock('../api/client', () => ({
  apiClient: {
    get: jest.fn(),
    post: jest.fn(),
  },
}));

// Time mock
jest.useFakeTimers();
jest.setSystemTime(new Date('2024-01-01'));

// Environment mock
const originalEnv = process.env;
beforeEach(() => {
  process.env = { ...originalEnv, API_KEY: 'test-key' };
});
afterEach(() => {
  process.env = originalEnv;
});
```

## 통합 테스트 가이드

### API 엔드포인트 테스트

```typescript
describe('POST /api/users', () => {
  it('should create user and return 201', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        name: 'Test User',
      })
      .expect(201);

    expect(response.body).toMatchObject({
      email: 'test@example.com',
      name: 'Test User',
    });
    expect(response.body.id).toBeDefined();
  });

  it('should return 400 for invalid email', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'invalid-email',
        name: 'Test User',
      })
      .expect(400);

    expect(response.body.error).toContain('email');
  });

  it('should return 409 for duplicate email', async () => {
    // First create
    await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test' });

    // Duplicate
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test 2' })
      .expect(409);

    expect(response.body.error).toContain('already exists');
  });
});
```

## 테스트 데이터 관리

### Factory 패턴

```typescript
// factories/user.factory.ts
export const createUser = (overrides?: Partial<User>): User => ({
  id: 'user-1',
  email: 'test@example.com',
  name: 'Test User',
  status: 'active',
  createdAt: new Date('2024-01-01'),
  ...overrides,
});

// Usage
const user = createUser({ status: 'pending' });
const adminUser = createUser({
  email: 'admin@example.com',
  role: 'admin',
});
```

### Fixture 데이터

```typescript
// fixtures/users.ts
export const fixtures = {
  validUser: {
    email: 'valid@example.com',
    name: 'Valid User',
  },
  invalidUser: {
    email: 'invalid-email',
    name: '',
  },
  adminUser: {
    email: 'admin@example.com',
    name: 'Admin',
    role: 'admin',
  },
};
```

## 커버리지 가이드라인

### 목표 커버리지

| 영역 | 목표 |
|------|------|
| Domain Layer | > 90% |
| Application Layer | > 80% |
| Infrastructure Layer | > 60% |
| Presentation Layer | > 70% |

### 커버리지 보고서 확인

```bash
# Jest
npm test -- --coverage

# pytest
pytest --cov=src --cov-report=html

# Go
go test -cover ./...
```

## AI 테스트 생성 출력 형식

```markdown
## 생성된 테스트

### 파일: `src/services/__tests__/user-service.test.ts`

```typescript
// 테스트 코드
```

### 테스트 케이스 목록
1. ✅ should create user with valid data
2. ✅ should throw for invalid email
3. ✅ should handle duplicate email
4. ✅ should return null for non-existent user

### 커버리지 예상
- Lines: ~85%
- Branches: ~80%
- Functions: ~90%
```

---

**참고**: 테스트 코드도 프로덕션 코드와 동일한 품질 기준을 적용합니다.
