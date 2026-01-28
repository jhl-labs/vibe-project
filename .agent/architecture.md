# Architecture Overview

> 시스템 아키텍처 설명서

## 아키텍처 원칙

### 핵심 원칙

1. **관심사의 분리 (Separation of Concerns)**
   - 각 레이어/모듈은 명확한 책임을 가짐
   - 비즈니스 로직과 인프라 코드 분리

2. **의존성 역전 (Dependency Inversion)**
   - 고수준 모듈이 저수준 모듈에 의존하지 않음
   - 추상화(인터페이스)에 의존

3. **단일 진실 공급원 (Single Source of Truth)**
   - 각 데이터는 하나의 위치에서만 관리
   - 중복 데이터 최소화

4. **실패를 위한 설계 (Design for Failure)**
   - 모든 외부 호출은 실패할 수 있음을 가정
   - 적절한 재시도, 서킷브레이커, 폴백 구현

## 레이어 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │    REST     │  │   GraphQL   │  │   gRPC      │         │
│  │    API      │  │    API      │  │   Service   │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
└─────────┼────────────────┼────────────────┼─────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    Use Cases                         │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐          │   │
│  │  │CreateUser│  │GetOrders │  │ProcessPay│          │   │
│  │  └──────────┘  └──────────┘  └──────────┘          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐   │
│  │   Entities    │  │    Value      │  │   Domain      │   │
│  │               │  │   Objects     │  │   Services    │   │
│  └───────────────┘  └───────────────┘  └───────────────┘   │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              Domain Events / Aggregates                │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Infrastructure Layer                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Repository│  │ External │  │  Message │  │  Cache   │   │
│  │   Impl   │  │   APIs   │  │   Queue  │  │  Client  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 레이어별 책임

### Presentation Layer

**책임:**
- HTTP 요청/응답 처리
- 입력 유효성 검증 (형식)
- 인증/인가 처리
- DTO 변환

**포함 요소:**
- Controllers / Handlers
- Middleware
- Request/Response DTOs
- API Documentation

```typescript
// Example: Controller
@Controller('/users')
class UserController {
  constructor(private createUserUseCase: CreateUserUseCase) {}

  @Post('/')
  async create(@Body() dto: CreateUserRequestDto): Promise<UserResponseDto> {
    const user = await this.createUserUseCase.execute(dto);
    return UserResponseDto.from(user);
  }
}
```

### Application Layer

**책임:**
- 유스케이스 오케스트레이션
- 트랜잭션 경계 관리
- 도메인 서비스 조합
- 애플리케이션 이벤트 발행

**포함 요소:**
- Use Cases / Application Services
- Command / Query Handlers
- Application Events
- DTO Mappers

```typescript
// Example: Use Case
class CreateUserUseCase {
  constructor(
    private userRepository: IUserRepository,
    private emailService: IEmailService,
    private eventBus: IEventBus
  ) {}

  async execute(data: CreateUserDto): Promise<User> {
    const user = User.create(data);
    await this.userRepository.save(user);
    await this.emailService.sendWelcome(user.email);
    await this.eventBus.publish(new UserCreatedEvent(user));
    return user;
  }
}
```

### Domain Layer

**책임:**
- 비즈니스 로직 캡슐화
- 비즈니스 규칙 강제
- 도메인 불변성 유지

**포함 요소:**
- Entities
- Value Objects
- Domain Services
- Domain Events
- Repository Interfaces

```typescript
// Example: Entity
class User {
  private constructor(
    public readonly id: UserId,
    public email: Email,
    public name: UserName,
    private status: UserStatus
  ) {}

  static create(data: CreateUserData): User {
    // Business validation
    if (!data.email.includes('@')) {
      throw new InvalidEmailError(data.email);
    }
    return new User(
      UserId.generate(),
      Email.create(data.email),
      UserName.create(data.name),
      UserStatus.PENDING
    );
  }

  activate(): void {
    if (this.status !== UserStatus.PENDING) {
      throw new InvalidStateTransitionError('User must be pending');
    }
    this.status = UserStatus.ACTIVE;
  }
}
```

### Infrastructure Layer

**책임:**
- 외부 시스템 통합
- 데이터 영속성 구현
- 기술적 관심사 처리

**포함 요소:**
- Repository Implementations
- External API Clients
- Message Queue Publishers/Consumers
- Cache Implementations
- Database Configurations

```typescript
// Example: Repository Implementation
class PostgresUserRepository implements IUserRepository {
  constructor(private db: DatabaseClient) {}

  async findById(id: UserId): Promise<User | null> {
    const row = await this.db.query(
      'SELECT * FROM users WHERE id = $1',
      [id.value]
    );
    return row ? this.toDomain(row) : null;
  }

  async save(user: User): Promise<void> {
    await this.db.query(
      'INSERT INTO users (id, email, name, status) VALUES ($1, $2, $3, $4)',
      [user.id.value, user.email.value, user.name.value, user.status]
    );
  }

  private toDomain(row: UserRow): User {
    // Map database row to domain entity
  }
}
```

## 디렉토리 구조

```
src/
├── presentation/           # Presentation Layer
│   ├── http/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   └── dto/
│   ├── graphql/
│   │   ├── resolvers/
│   │   └── schema/
│   └── grpc/
│
├── application/            # Application Layer
│   ├── use-cases/
│   │   ├── user/
│   │   ├── order/
│   │   └── payment/
│   ├── services/
│   └── events/
│
├── domain/                 # Domain Layer
│   ├── user/
│   │   ├── entity.ts
│   │   ├── value-objects/
│   │   ├── repository.ts   # Interface
│   │   └── events/
│   ├── order/
│   └── shared/
│       ├── entity.ts
│       └── value-object.ts
│
├── infrastructure/         # Infrastructure Layer
│   ├── persistence/
│   │   ├── postgres/
│   │   └── redis/
│   ├── external/
│   │   ├── payment-gateway/
│   │   └── email-service/
│   ├── messaging/
│   │   └── rabbitmq/
│   └── config/
│
└── shared/                 # Cross-cutting concerns
    ├── errors/
    ├── logging/
    └── utils/
```

## 통신 패턴

### 동기 통신

```
┌──────────┐     HTTP/gRPC      ┌──────────┐
│ Service A│ ──────────────────▶│ Service B│
└──────────┘                    └──────────┘
```

### 비동기 통신 (이벤트 기반)

```
┌──────────┐     Publish        ┌──────────┐     Subscribe      ┌──────────┐
│ Service A│ ──────────────────▶│  Message │ ◀─────────────────│ Service B│
└──────────┘                    │   Queue  │                    └──────────┘
                                └──────────┘
```

## 데이터 흐름

### 요청 처리 흐름

```
Client Request
     │
     ▼
┌─────────────────┐
│   Controller    │ ─── 입력 검증, 인증 확인
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Use Case      │ ─── 비즈니스 오케스트레이션
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Domain Service  │ ─── 비즈니스 로직 실행
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Repository    │ ─── 데이터 영속화
└────────┬────────┘
         │
         ▼
    Database
```

## 참고 자료

- [Architecture Decision Records](../docs/adr/)
- [API Documentation](../docs/api/)
- [Development Guide](../docs/guides/development.md)

---

**Note**: 이 문서는 프로젝트의 실제 아키텍처에 맞게 수정하세요.
