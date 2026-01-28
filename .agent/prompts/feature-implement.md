# Feature Implementation Prompt

## 목적
새로운 기능을 체계적으로 구현합니다.

## 컨텍스트
기능 요구사항과 기존 코드베이스 구조를 이해해야 합니다.

---

## 프롬프트 템플릿

```
새로운 기능을 구현해야 해.

### 기능 설명
[구현할 기능에 대한 상세 설명]

### 사용자 스토리
As a [사용자 유형]
I want [원하는 기능]
So that [기대 효과]

### 수락 조건 (Acceptance Criteria)
- [ ] [조건 1]
- [ ] [조건 2]
- [ ] [조건 3]

### 기술적 요구사항
- [요구사항 1]
- [요구사항 2]

### 관련 기존 코드
- [참고할 파일 1]
- [참고할 파일 2]

### 제약 조건
- [성능 요구사항]
- [보안 요구사항]
- [호환성 요구사항]

다음을 제공해줘:
1. 구현 계획
2. 필요한 파일 변경/생성 목록
3. 구현 코드
4. 테스트 코드
```

---

## 출력 형식

```markdown
## 구현 계획

### 분석
[요구사항 분석 결과]

### 설계 결정
[주요 설계 결정과 이유]

### 파일 변경 목록
| 파일 | 변경 유형 | 설명 |
|------|----------|------|
| path/file.ts | 신규 | ... |
| path/file2.ts | 수정 | ... |

### 구현

#### 1. [컴포넌트/모듈 이름]
\`\`\`
[코드]
\`\`\`

### 테스트

\`\`\`
[테스트 코드]
\`\`\`

### 검증 방법
[기능이 제대로 동작하는지 확인하는 방법]
```

---

## 예시

### 입력
```
새로운 기능을 구현해야 해.

### 기능 설명
사용자가 자신의 활동 로그를 조회할 수 있는 기능

### 사용자 스토리
As a 일반 사용자
I want 내 계정의 활동 로그(로그인, 설정 변경 등)를 조회
So that 보안 이상 징후를 확인할 수 있음

### 수락 조건 (Acceptance Criteria)
- [ ] 최근 30일간의 활동 로그 조회 가능
- [ ] 활동 유형별 필터링 가능 (로그인, 설정변경, 데이터조회)
- [ ] 날짜 범위로 검색 가능
- [ ] 페이지네이션 지원

### 기술적 요구사항
- REST API로 제공
- 응답 시간 500ms 이내

### 관련 기존 코드
- src/modules/user/ - 사용자 모듈
- src/modules/audit/ - 기존 감사 로그 (관리자용)

### 제약 조건
- 본인의 로그만 조회 가능 (타인 로그 접근 불가)
- 민감 정보(IP, 상세 요청 내용)는 마스킹
```

### 출력
```markdown
## 구현 계획

### 분석
기존 관리자용 감사 로그(`audit` 모듈)를 활용하되,
일반 사용자 접근용 API와 데이터 필터링 레이어를 추가합니다.

### 설계 결정
1. **별도 컨트롤러 생성**: 사용자용 API는 `/api/v1/me/activity-logs`로 분리
2. **기존 모델 재사용**: `AuditLog` 모델을 공유, 쿼리만 제한
3. **DTO 분리**: 민감 정보 마스킹을 위한 별도 응답 DTO 생성

### 파일 변경 목록
| 파일 | 변경 유형 | 설명 |
|------|----------|------|
| src/modules/user/activity-log.controller.ts | 신규 | 사용자 활동 로그 API |
| src/modules/user/activity-log.service.ts | 신규 | 비즈니스 로직 |
| src/modules/user/dto/activity-log.dto.ts | 신규 | 요청/응답 DTO |
| src/modules/user/user.module.ts | 수정 | 새 컨트롤러 등록 |

### 구현

#### 1. Activity Log DTO
\`\`\`typescript
// dto/activity-log.dto.ts
export class ActivityLogResponseDto {
  id: string;
  activityType: string;
  description: string;
  ipAddress: string; // 마스킹됨: 192.168.xxx.xxx
  createdAt: Date;

  static fromEntity(log: AuditLog): ActivityLogResponseDto {
    return {
      id: log.id,
      activityType: log.type,
      description: log.description,
      ipAddress: this.maskIp(log.ipAddress),
      createdAt: log.createdAt,
    };
  }

  private static maskIp(ip: string): string {
    const parts = ip.split('.');
    return `${parts[0]}.${parts[1]}.xxx.xxx`;
  }
}

export class GetActivityLogsQueryDto {
  @IsOptional()
  @IsEnum(ActivityType)
  type?: ActivityType;

  @IsOptional()
  @IsDateString()
  startDate?: string;

  @IsOptional()
  @IsDateString()
  endDate?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number = 1;

  @IsOptional()
  @IsInt()
  @Max(100)
  limit?: number = 20;
}
\`\`\`

#### 2. Activity Log Service
\`\`\`typescript
// activity-log.service.ts
@Injectable()
export class ActivityLogService {
  constructor(
    @InjectRepository(AuditLog)
    private auditLogRepo: Repository<AuditLog>,
  ) {}

  async getUserActivityLogs(
    userId: string,
    query: GetActivityLogsQueryDto,
  ): Promise<PaginatedResult<ActivityLogResponseDto>> {
    const qb = this.auditLogRepo
      .createQueryBuilder('log')
      .where('log.userId = :userId', { userId })
      .andWhere('log.createdAt >= :thirtyDaysAgo', {
        thirtyDaysAgo: subDays(new Date(), 30),
      });

    if (query.type) {
      qb.andWhere('log.type = :type', { type: query.type });
    }

    // ... 날짜 필터, 페이지네이션 적용

    const [logs, total] = await qb.getManyAndCount();

    return {
      data: logs.map(ActivityLogResponseDto.fromEntity),
      total,
      page: query.page,
      limit: query.limit,
    };
  }
}
\`\`\`

#### 3. Activity Log Controller
\`\`\`typescript
// activity-log.controller.ts
@Controller('me/activity-logs')
@UseGuards(AuthGuard)
export class ActivityLogController {
  constructor(private activityLogService: ActivityLogService) {}

  @Get()
  async getMyActivityLogs(
    @CurrentUser() user: User,
    @Query() query: GetActivityLogsQueryDto,
  ): Promise<PaginatedResult<ActivityLogResponseDto>> {
    return this.activityLogService.getUserActivityLogs(user.id, query);
  }
}
\`\`\`

### 테스트

\`\`\`typescript
describe('ActivityLogService', () => {
  it('should return only logs for the requesting user', async () => {
    // Given
    const userId = 'user-1';
    const otherUserId = 'user-2';
    await createTestLogs([
      { userId, type: 'LOGIN' },
      { userId: otherUserId, type: 'LOGIN' },
    ]);

    // When
    const result = await service.getUserActivityLogs(userId, {});

    // Then
    expect(result.data).toHaveLength(1);
    expect(result.data[0].userId).toBe(userId);
  });

  it('should mask IP addresses', async () => {
    // Given
    await createTestLog({ userId, ipAddress: '192.168.1.100' });

    // When
    const result = await service.getUserActivityLogs(userId, {});

    // Then
    expect(result.data[0].ipAddress).toBe('192.168.xxx.xxx');
  });
});
\`\`\`

### 검증 방법
1. API 호출: `GET /api/v1/me/activity-logs`
2. 타 사용자 로그 접근 시도 → 빈 결과 확인
3. 필터링/페이지네이션 동작 확인
4. IP 마스킹 확인
```

---

## 체크리스트

구현 완료 후 확인:
- [ ] 모든 수락 조건 충족
- [ ] 테스트 코드 작성
- [ ] 에러 처리 구현
- [ ] 로깅 추가
- [ ] API 문서 업데이트
- [ ] 성능 요구사항 충족
