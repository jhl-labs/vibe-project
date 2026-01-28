# API Documentation Prompt

## 목적
API에 대한 명확하고 사용하기 쉬운 문서를 작성합니다.

## 컨텍스트
API 엔드포인트의 기능, 파라미터, 응답 형식을 문서화합니다.

---

## 프롬프트 템플릿

```
API 문서를 작성해줘.

### 문서화 대상
[파일 경로 또는 API 설명]

### 문서 형식
[OpenAPI/Swagger / Markdown / 기타]

### 포함할 내용
- [ ] 엔드포인트 설명
- [ ] Request/Response 스키마
- [ ] 인증 정보
- [ ] 에러 코드
- [ ] 예시 코드

### 대상 독자
[프론트엔드 개발자 / 외부 파트너 / 등]

다음을 제공해줘:
1. API 개요
2. 인증 가이드
3. 각 엔드포인트 상세 문서
4. 에러 코드 목록
5. 예시 코드
```

---

## 출력 형식

```markdown
# API 문서: [API 이름]

## 개요
[API의 목적과 주요 기능]

## Base URL
\`https://api.example.com/v1\`

## 인증
[인증 방식 설명]

## 엔드포인트

### [엔드포인트 이름]

**[METHOD]** \`/path\`

[설명]

#### Request

**Headers**
| 이름 | 필수 | 설명 |
|------|------|------|
| ... | ... | ... |

**Body**
\`\`\`json
{...}
\`\`\`

#### Response

**Success (200)**
\`\`\`json
{...}
\`\`\`

**Error**
| 코드 | 설명 |
|------|------|
| 400 | ... |

## 에러 코드
[공통 에러 코드]

## 예시
[언어별 예시 코드]
```

---

## 예시

### 입력
```
API 문서를 작성해줘.

### 문서화 대상
사용자 관리 API (src/controllers/user.controller.ts)
- 사용자 생성
- 사용자 조회
- 사용자 수정
- 사용자 삭제

### 문서 형식
Markdown

### 포함할 내용
- [x] 엔드포인트 설명
- [x] Request/Response 스키마
- [x] 인증 정보
- [x] 에러 코드
- [x] 예시 코드

### 대상 독자
프론트엔드 개발자
```

### 출력
```markdown
# User API

사용자 계정을 관리하기 위한 API입니다.

## Base URL

\`\`\`
https://api.example.com/v1
\`\`\`

## 인증

모든 API 요청에는 Authorization 헤더가 필요합니다.

\`\`\`
Authorization: Bearer <access_token>
\`\`\`

토큰은 `/auth/login` 엔드포인트에서 발급받을 수 있습니다.

---

## 엔드포인트

### 사용자 생성

새로운 사용자를 생성합니다.

**POST** \`/users\`

#### Request

**Headers**
| 이름 | 필수 | 설명 |
|------|------|------|
| Authorization | Yes | Bearer 토큰 |
| Content-Type | Yes | application/json |

**Body**
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| email | string | Yes | 이메일 주소 (유니크) |
| name | string | Yes | 사용자 이름 (2-50자) |
| password | string | Yes | 비밀번호 (8자 이상) |

\`\`\`json
{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "securePassword123"
}
\`\`\`

#### Response

**Success (201 Created)**
\`\`\`json
{
  "id": "user_abc123",
  "email": "user@example.com",
  "name": "John Doe",
  "status": "active",
  "createdAt": "2024-01-15T10:30:00Z"
}
\`\`\`

**Error Responses**
| 코드 | 에러 | 설명 |
|------|------|------|
| 400 | VALIDATION_ERROR | 입력값 유효성 검증 실패 |
| 409 | DUPLICATE_EMAIL | 이미 존재하는 이메일 |

---

### 사용자 조회

특정 사용자의 정보를 조회합니다.

**GET** \`/users/{userId}\`

#### Request

**Path Parameters**
| 이름 | 타입 | 설명 |
|------|------|------|
| userId | string | 사용자 ID |

#### Response

**Success (200 OK)**
\`\`\`json
{
  "id": "user_abc123",
  "email": "user@example.com",
  "name": "John Doe",
  "status": "active",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
\`\`\`

**Error Responses**
| 코드 | 에러 | 설명 |
|------|------|------|
| 404 | USER_NOT_FOUND | 사용자를 찾을 수 없음 |

---

### 사용자 목록 조회

사용자 목록을 페이지네이션으로 조회합니다.

**GET** \`/users\`

#### Request

**Query Parameters**
| 이름 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| page | integer | 1 | 페이지 번호 |
| limit | integer | 20 | 페이지당 항목 수 (최대 100) |
| status | string | - | 필터: active, inactive |
| q | string | - | 이름/이메일 검색 |

#### Response

**Success (200 OK)**
\`\`\`json
{
  "data": [
    {
      "id": "user_abc123",
      "email": "user@example.com",
      "name": "John Doe",
      "status": "active"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
\`\`\`

---

### 사용자 수정

사용자 정보를 수정합니다.

**PATCH** \`/users/{userId}\`

#### Request

**Body**
| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| name | string | No | 새 이름 |
| email | string | No | 새 이메일 |

\`\`\`json
{
  "name": "Jane Doe"
}
\`\`\`

#### Response

**Success (200 OK)**
\`\`\`json
{
  "id": "user_abc123",
  "email": "user@example.com",
  "name": "Jane Doe",
  "status": "active",
  "updatedAt": "2024-01-16T09:00:00Z"
}
\`\`\`

---

### 사용자 삭제

사용자를 비활성화합니다 (소프트 삭제).

**DELETE** \`/users/{userId}\`

#### Response

**Success (204 No Content)**

빈 응답

---

## 공통 에러 코드

| HTTP 코드 | 에러 코드 | 설명 |
|-----------|-----------|------|
| 400 | VALIDATION_ERROR | 입력값 검증 실패 |
| 401 | UNAUTHORIZED | 인증 필요 |
| 403 | FORBIDDEN | 권한 없음 |
| 404 | NOT_FOUND | 리소스 없음 |
| 409 | CONFLICT | 리소스 충돌 |
| 429 | RATE_LIMITED | 요청 한도 초과 |
| 500 | INTERNAL_ERROR | 서버 오류 |

### 에러 응답 형식

\`\`\`json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "이메일 형식이 올바르지 않습니다.",
    "details": [
      {
        "field": "email",
        "message": "유효한 이메일 주소를 입력하세요."
      }
    ]
  }
}
\`\`\`

---

## 예시 코드

### JavaScript (Fetch)

\`\`\`javascript
// 사용자 생성
const response = await fetch('https://api.example.com/v1/users', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    email: 'user@example.com',
    name: 'John Doe',
    password: 'securePassword123',
  }),
});

const user = await response.json();
console.log(user);
\`\`\`

### Python (Requests)

\`\`\`python
import requests

# 사용자 생성
response = requests.post(
    'https://api.example.com/v1/users',
    headers={
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    },
    json={
        'email': 'user@example.com',
        'name': 'John Doe',
        'password': 'securePassword123',
    },
)

user = response.json()
print(user)
\`\`\`

### cURL

\`\`\`bash
# 사용자 생성
curl -X POST https://api.example.com/v1/users \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "name": "John Doe",
    "password": "securePassword123"
  }'
\`\`\`
```

---

## 문서화 체크리스트

- [ ] 모든 엔드포인트 문서화
- [ ] Request/Response 스키마 정확성
- [ ] 에러 코드 완전성
- [ ] 예시 코드 동작 확인
- [ ] 인증 방식 명확
- [ ] 페이지네이션 설명
- [ ] Rate limiting 정보
