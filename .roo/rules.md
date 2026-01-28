# Roo Code Rules

## Project Information

- **Name**: <project-name>
- **Type**: <project-type>
- **Language**: <primary-language>
- **Framework**: <framework>

## Coding Standards

### Style Guide

- Use consistent indentation (2 spaces)
- Maximum line length: 100 characters
- Use meaningful names for variables, functions, and classes
- Follow language-specific conventions

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | kebab-case | `user-service.ts` |
| Classes | PascalCase | `UserService` |
| Functions | camelCase | `getUserById` |
| Variables | camelCase | `userName` |
| Constants | UPPER_SNAKE | `MAX_RETRIES` |
| Types | PascalCase | `UserData` |

### Code Organization

```
src/
├── domain/         # Business logic
├── application/    # Use cases
├── infrastructure/ # External integrations
└── presentation/   # API/UI layer
```

## Development Guidelines

### Do's

- Write clean, self-documenting code
- Add tests for new functionality
- Handle errors gracefully
- Use environment variables for config
- Follow existing patterns in codebase
- Document public APIs

### Don'ts

- Hardcode secrets or credentials
- Skip error handling
- Write overly complex functions
- Ignore existing code style
- Commit without testing
- Leave TODO comments without issues

## Testing Requirements

- Unit tests for business logic
- Integration tests for APIs
- Test coverage > 80% for critical paths
- Use descriptive test names

## Security Guidelines

- Validate all user inputs
- Use parameterized queries
- Never log sensitive data
- Keep dependencies updated
- Follow OWASP guidelines

## Git Workflow

### Commit Messages

Use conventional commits:
```
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Branch Naming

- `feature/<description>`
- `fix/<description>`
- `hotfix/<description>`
- `release/<version>`

## AI Assistance Rules

When generating code:
1. Follow existing patterns
2. Include proper error handling
3. Add necessary imports
4. Write accompanying tests

When reviewing code:
1. Check security first
2. Verify error handling
3. Assess readability
4. Suggest improvements

## Reference

See `CLAUDE.md` for detailed project instructions.
