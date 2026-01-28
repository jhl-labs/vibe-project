# Test Generation Prompt

## 목적
주어진 코드에 대한 효과적인 테스트를 생성합니다.

## 컨텍스트
테스트 대상 코드의 기능과 프로젝트의 테스트 규칙을 이해해야 합니다.

---

## 프롬프트 템플릿

```
다음 코드에 대한 테스트를 작성해줘.

### 테스트 대상
[파일 경로 또는 코드]

### 테스트 유형
- [ ] 단위 테스트
- [ ] 통합 테스트
- [ ] E2E 테스트

### 테스트 프레임워크
[Jest/Pytest/JUnit 등]

### 테스트 중점 사항
- [테스트할 주요 시나리오]
- [엣지 케이스]
- [에러 케이스]

### 모킹 필요 사항
- [모킹할 의존성]

다음을 제공해줘:
1. 테스트 케이스 목록
2. 테스트 코드
3. 테스트 커버리지 분석
```

---

## 출력 형식

```markdown
## 테스트 계획

### 테스트 케이스 목록
| # | 시나리오 | 유형 | 우선순위 |
|---|----------|------|----------|
| 1 | ... | Happy path | High |
| 2 | ... | Edge case | Medium |
| 3 | ... | Error case | High |

### 테스트 코드

\`\`\`
[테스트 코드]
\`\`\`

### 커버리지 분석
- 라인 커버리지 예상: X%
- 브랜치 커버리지 예상: X%
- 추가 권장 테스트: [...]
```

---

## 예시

### 입력
```
다음 코드에 대한 테스트를 작성해줘.

### 테스트 대상
\`\`\`typescript
// user.service.ts
export class UserService {
  constructor(
    private userRepo: UserRepository,
    private emailService: EmailService
  ) {}

  async createUser(email: string, name: string): Promise<User> {
    const existing = await this.userRepo.findByEmail(email);
    if (existing) {
      throw new DuplicateEmailError(email);
    }

    const user = await this.userRepo.create({ email, name });
    await this.emailService.sendWelcome(user.email);
    return user;
  }

  async updateUser(id: string, data: UpdateUserDto): Promise<User> {
    const user = await this.userRepo.findById(id);
    if (!user) {
      throw new UserNotFoundError(id);
    }

    if (data.email && data.email !== user.email) {
      const existing = await this.userRepo.findByEmail(data.email);
      if (existing) {
        throw new DuplicateEmailError(data.email);
      }
    }

    return this.userRepo.update(id, data);
  }
}
\`\`\`

### 테스트 유형
- [x] 단위 테스트

### 테스트 프레임워크
Jest

### 모킹 필요 사항
- UserRepository
- EmailService
```

### 출력
```markdown
## 테스트 계획

### 테스트 케이스 목록

#### createUser
| # | 시나리오 | 유형 | 우선순위 |
|---|----------|------|----------|
| 1 | 새 사용자 생성 성공 | Happy path | High |
| 2 | 중복 이메일로 생성 실패 | Error case | High |
| 3 | 이메일 발송 실패해도 사용자 생성됨 | Edge case | Medium |

#### updateUser
| # | 시나리오 | 유형 | 우선순위 |
|---|----------|------|----------|
| 4 | 사용자 정보 수정 성공 | Happy path | High |
| 5 | 존재하지 않는 사용자 수정 실패 | Error case | High |
| 6 | 이메일 변경 시 중복 체크 | Edge case | High |
| 7 | 이메일 변경 없이 다른 정보만 수정 | Edge case | Medium |

### 테스트 코드

\`\`\`typescript
import { UserService } from './user.service';
import { DuplicateEmailError, UserNotFoundError } from './errors';

describe('UserService', () => {
  let service: UserService;
  let mockUserRepo: jest.Mocked<UserRepository>;
  let mockEmailService: jest.Mocked<EmailService>;

  beforeEach(() => {
    mockUserRepo = {
      findByEmail: jest.fn(),
      findById: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    };
    mockEmailService = {
      sendWelcome: jest.fn(),
    };
    service = new UserService(mockUserRepo, mockEmailService);
  });

  describe('createUser', () => {
    const email = 'test@example.com';
    const name = 'Test User';

    it('should create user and send welcome email', async () => {
      // Given
      const newUser = { id: '1', email, name };
      mockUserRepo.findByEmail.mockResolvedValue(null);
      mockUserRepo.create.mockResolvedValue(newUser);
      mockEmailService.sendWelcome.mockResolvedValue(undefined);

      // When
      const result = await service.createUser(email, name);

      // Then
      expect(result).toEqual(newUser);
      expect(mockUserRepo.create).toHaveBeenCalledWith({ email, name });
      expect(mockEmailService.sendWelcome).toHaveBeenCalledWith(email);
    });

    it('should throw DuplicateEmailError if email exists', async () => {
      // Given
      mockUserRepo.findByEmail.mockResolvedValue({ id: '1', email, name });

      // When & Then
      await expect(service.createUser(email, name))
        .rejects
        .toThrow(DuplicateEmailError);
      expect(mockUserRepo.create).not.toHaveBeenCalled();
    });

    it('should create user even if email sending fails', async () => {
      // Given
      const newUser = { id: '1', email, name };
      mockUserRepo.findByEmail.mockResolvedValue(null);
      mockUserRepo.create.mockResolvedValue(newUser);
      mockEmailService.sendWelcome.mockRejectedValue(new Error('SMTP error'));

      // When & Then
      await expect(service.createUser(email, name))
        .rejects
        .toThrow('SMTP error');
      // Note: 현재 구현에서는 이메일 실패 시 예외 발생
      // 만약 이메일 실패를 무시해야 한다면 코드 수정 필요
    });
  });

  describe('updateUser', () => {
    const userId = '1';
    const existingUser = {
      id: userId,
      email: 'old@example.com',
      name: 'Old Name',
    };

    it('should update user successfully', async () => {
      // Given
      const updateData = { name: 'New Name' };
      const updatedUser = { ...existingUser, ...updateData };
      mockUserRepo.findById.mockResolvedValue(existingUser);
      mockUserRepo.update.mockResolvedValue(updatedUser);

      // When
      const result = await service.updateUser(userId, updateData);

      // Then
      expect(result).toEqual(updatedUser);
      expect(mockUserRepo.update).toHaveBeenCalledWith(userId, updateData);
    });

    it('should throw UserNotFoundError if user does not exist', async () => {
      // Given
      mockUserRepo.findById.mockResolvedValue(null);

      // When & Then
      await expect(service.updateUser(userId, { name: 'New' }))
        .rejects
        .toThrow(UserNotFoundError);
    });

    it('should check email uniqueness when changing email', async () => {
      // Given
      const newEmail = 'new@example.com';
      mockUserRepo.findById.mockResolvedValue(existingUser);
      mockUserRepo.findByEmail.mockResolvedValue({ id: '2', email: newEmail });

      // When & Then
      await expect(service.updateUser(userId, { email: newEmail }))
        .rejects
        .toThrow(DuplicateEmailError);
    });

    it('should not check email uniqueness if email unchanged', async () => {
      // Given
      const updateData = { email: existingUser.email, name: 'New Name' };
      mockUserRepo.findById.mockResolvedValue(existingUser);
      mockUserRepo.update.mockResolvedValue({ ...existingUser, ...updateData });

      // When
      await service.updateUser(userId, updateData);

      // Then
      expect(mockUserRepo.findByEmail).not.toHaveBeenCalled();
    });
  });
});
\`\`\`

### 커버리지 분석
- 라인 커버리지 예상: 95%
- 브랜치 커버리지 예상: 100%

### 추가 권장 테스트
1. **이메일 발송 실패 처리** - 현재 구현에서는 예외가 전파됨. 비즈니스 요구사항에 따라 try-catch로 무시하도록 수정 검토
2. **동시성 테스트** - 동일 이메일로 동시 가입 시도 시 하나만 성공하는지
3. **입력 유효성** - 빈 이메일, 빈 이름 등 유효성 검사 테스트
```

---

## 테스트 작성 원칙

### AAA 패턴
- **Arrange**: 테스트 데이터 준비
- **Act**: 테스트 대상 실행
- **Assert**: 결과 검증

### 테스트 명명
- `should [expected behavior] when [condition]`
- `[method name] - [scenario]`

### Mock vs Stub vs Spy
- **Mock**: 호출 여부/횟수 검증
- **Stub**: 고정된 응답 반환
- **Spy**: 실제 동작 + 호출 기록
