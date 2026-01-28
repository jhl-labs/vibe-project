# Vibe Project Template

> 엔터프라이즈급 AI-Assisted 개발을 위한 프로젝트 템플릿

[![CI](https://github.com/<your-org>/<your-project>/actions/workflows/ci.yml/badge.svg)](https://github.com/<your-org>/<your-project>/actions/workflows/ci.yml)
[![Security Scan](https://github.com/<your-org>/<your-project>/actions/workflows/security-scan.yml/badge.svg)](https://github.com/<your-org>/<your-project>/actions/workflows/security-scan.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

이 템플릿은 **Vibe Coding** 방법론을 지원하는 엔터프라이즈급 프로젝트 구조를 제공합니다. AI 에이전트(Claude, Cursor, Roo)와 협업하여 효율적인 개발 환경을 구축할 수 있습니다.

### 핵심 기능

- **AI Agent 통합**: Claude Code, Cursor AI, Roo Code 지원
- **자동화된 CI/CD**: GitHub Actions 기반 파이프라인
- **보안 내장**: 보안 스캔, 의존성 검사, 코드 리뷰 자동화
- **표준화된 문서**: ADR, API 문서, 개발 가이드

## Quick Start

### 1. 템플릿으로 저장소 생성

```bash
# GitHub에서 "Use this template" 버튼 클릭
# 또는 GitHub CLI 사용
gh repo create my-project --template <your-org>/vibe-project-template
```

### 2. 프로젝트 초기화

```bash
# 저장소 클론
git clone https://github.com/<your-org>/my-project.git
cd my-project

# 초기화 스크립트 실행
./scripts/init-project.sh
```

### 3. AI 에이전트와 협업 시작

```bash
# Claude Code 사용
claude

# 또는 Cursor AI에서 프로젝트 열기
cursor .
```

## 프로젝트 구조

```
.
├── .github/                    # GitHub 설정
│   ├── workflows/              # CI/CD 파이프라인
│   ├── ISSUE_TEMPLATE/         # 이슈 템플릿
│   └── PULL_REQUEST_TEMPLATE.md
├── .agent/                     # AI 에이전트 설정
│   ├── context.md              # 프로젝트 컨텍스트
│   ├── conventions.md          # 코딩 컨벤션
│   ├── skills/                 # 에이전트 스킬
│   └── subagents/              # 서브 에이전트
├── docs/                       # 문서
│   ├── adr/                    # Architecture Decision Records
│   ├── api/                    # API 문서
│   └── guides/                 # 개발 가이드
├── scripts/                    # 유틸리티 스크립트
├── CLAUDE.md                   # Claude Code 설정
├── .cursorrules                # Cursor AI 설정
└── .roo/                       # Roo Code 설정
```

## AI 에이전트 설정

### Claude Code

`CLAUDE.md` 파일이 프로젝트 루트에 위치하여 Claude Code의 동작을 정의합니다.

### Cursor AI

`.cursorrules` 파일이 Cursor AI의 코드 생성 규칙을 정의합니다.

### Roo Code

`.roo/rules.md` 파일이 Roo Code의 규칙을 정의합니다.

## 문서

- [시작 가이드](docs/guides/getting-started.md)
- [개발 가이드](docs/guides/development.md)
- [기여 가이드](CONTRIBUTING.md)
- [보안 정책](SECURITY.md)
- [ADR 템플릿](docs/adr/template.md)

## 기여하기

기여를 환영합니다! [CONTRIBUTING.md](CONTRIBUTING.md)를 참조하세요.

## 보안

보안 취약점을 발견하셨나요? [SECURITY.md](SECURITY.md)를 참조하여 보고해 주세요.

## 라이선스

이 프로젝트는 [MIT 라이선스](LICENSE)를 따릅니다.

---

**Made with Vibe Coding**
