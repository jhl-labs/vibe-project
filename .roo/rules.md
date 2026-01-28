# Roo Code Rules

> Roo Code AI 어시스턴트를 위한 프로젝트 규칙

## 새로운 규칙 시스템 안내

Roo Code는 `.mdc` 파일 형식을 지원합니다:

```
.roo/
├── rules/
│   └── general.mdc    # 일반 규칙 (.mdc 형식)
└── rules.md           # 기본 규칙 (이 파일)
```

**팁**: Cursor를 함께 사용한다면 `.cursor/rules/`의 `.mdc` 파일을
심볼릭 링크로 연결하여 규칙을 공유할 수 있습니다:

```bash
ln -s ../.cursor/rules/general.mdc .roo/rules/general.mdc
```

---

## Project Information

- **Name**: <project-name>
- **Type**: <project-type>
- **Language**: <primary-language>
- **Framework**: <framework>

## Core Principles

1. **Follow existing patterns** - Match the codebase style
2. **Keep it simple** - Avoid over-engineering
3. **Write tests** - Cover critical paths
4. **Handle errors** - Never swallow exceptions

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | kebab-case | `user-service.ts` |
| Classes | PascalCase | `UserService` |
| Functions | camelCase | `getUserById` |
| Variables | camelCase | `userName` |
| Constants | UPPER_SNAKE | `MAX_RETRIES` |

## Code Organization (Clean Architecture)

```
src/
├── domain/         # Business logic (PURE, no dependencies)
├── application/    # Use cases, orchestration
├── infrastructure/ # External integrations, DB
└── presentation/   # API/UI layer
```

## Security (CRITICAL)

**NEVER:**
- Hardcode secrets or credentials
- Use eval() or dynamic code execution
- Trust user input without validation
- Expose sensitive data in logs

**ALWAYS:**
- Validate and sanitize all inputs
- Use parameterized queries
- Use environment variables for config

## Git Workflow

### Conventional Commits
```
type(scope): description
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Branch Naming
- `feature/<description>`
- `fix/<description>`
- `hotfix/<description>`

## AI Assistance Rules

**When generating code:**
1. Follow existing patterns
2. Include proper error handling
3. Add necessary imports
4. Write accompanying tests

**When reviewing code:**
1. Check security first
2. Verify error handling
3. Assess readability
4. Suggest improvements

## Reference

- `CLAUDE.md` - Full project instructions
- `.agent/context.md` - Project context
- `.roo/rules/*.mdc` - Detailed rules (NEW)
