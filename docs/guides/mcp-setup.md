# MCP (Model Context Protocol) 설정 가이드

MCP를 사용하여 AI Agent의 기능을 확장하는 방법을 설명합니다.

## MCP란?

Model Context Protocol(MCP)은 AI 모델에게 외부 도구와 컨텍스트를 제공하는 표준 프로토콜입니다.

### 주요 개념

- **Server**: 도구와 리소스를 제공하는 서버
- **Tool**: AI가 호출할 수 있는 함수
- **Resource**: AI가 읽을 수 있는 데이터
- **Prompt**: 사전 정의된 프롬프트 템플릿

## 설정 파일

### Claude Desktop 설정

`~/.config/claude/claude_desktop_config.json` (Linux/Mac)
`%APPDATA%\Claude\claude_desktop_config.json` (Windows)

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "/path/to/project"]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-git"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "your-github-token"
      }
    }
  }
}
```

### Claude Code 설정

`.mcp.json` (프로젝트 루트)

```json
{
  "mcpServers": {
    "database": {
      "command": "npx",
      "args": ["-y", "mcp-server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "custom": {
      "command": "node",
      "args": ["./scripts/mcp-server.js"]
    }
  }
}
```

## 권장 MCP 서버

### 개발 도구

| 서버 | 설명 | 용도 |
|------|------|------|
| @anthropic-ai/mcp-server-filesystem | 파일 시스템 접근 | 파일 읽기/쓰기 |
| @anthropic-ai/mcp-server-git | Git 작업 | 버전 관리 |
| @anthropic-ai/mcp-server-github | GitHub API | PR, 이슈 관리 |
| mcp-server-postgres | PostgreSQL | DB 쿼리 |
| mcp-server-sqlite | SQLite | 로컬 DB |

### 생산성 도구

| 서버 | 설명 | 용도 |
|------|------|------|
| mcp-server-slack | Slack 연동 | 메시지 전송 |
| mcp-server-notion | Notion 연동 | 문서 관리 |
| mcp-server-linear | Linear 연동 | 이슈 트래킹 |

## 프로젝트별 MCP 구성

### 웹 개발 프로젝트

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "."]
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-git"]
    },
    "browser": {
      "command": "npx",
      "args": ["-y", "mcp-server-puppeteer"]
    }
  }
}
```

### 백엔드 API 프로젝트

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "."]
    },
    "database": {
      "command": "npx",
      "args": ["-y", "mcp-server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "http": {
      "command": "npx",
      "args": ["-y", "mcp-server-fetch"]
    }
  }
}
```

### 데이터 분석 프로젝트

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "./data"]
    },
    "jupyter": {
      "command": "python",
      "args": ["-m", "mcp_server_jupyter"]
    },
    "database": {
      "command": "npx",
      "args": ["-y", "mcp-server-sqlite", "./data/analysis.db"]
    }
  }
}
```

## 커스텀 MCP 서버 개발

### 기본 구조 (TypeScript)

```typescript
// mcp-server.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server(
  {
    name: "my-custom-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
      resources: {},
    },
  }
);

// 도구 정의
server.setRequestHandler("tools/list", async () => ({
  tools: [
    {
      name: "my_tool",
      description: "내 커스텀 도구",
      inputSchema: {
        type: "object",
        properties: {
          query: { type: "string", description: "쿼리" },
        },
        required: ["query"],
      },
    },
  ],
}));

// 도구 실행
server.setRequestHandler("tools/call", async (request) => {
  if (request.params.name === "my_tool") {
    const result = await executeMyTool(request.params.arguments);
    return { content: [{ type: "text", text: result }] };
  }
  throw new Error("Unknown tool");
});

// 서버 시작
const transport = new StdioServerTransport();
await server.connect(transport);
```

### 기본 구조 (Python)

```python
# mcp_server.py
from mcp.server import Server
from mcp.server.stdio import stdio_server

server = Server("my-custom-server")

@server.list_tools()
async def list_tools():
    return [
        {
            "name": "my_tool",
            "description": "내 커스텀 도구",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "query": {"type": "string", "description": "쿼리"}
                },
                "required": ["query"]
            }
        }
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "my_tool":
        result = await execute_my_tool(arguments["query"])
        return [{"type": "text", "text": result}]
    raise ValueError(f"Unknown tool: {name}")

if __name__ == "__main__":
    import asyncio
    asyncio.run(stdio_server(server))
```

## 보안 고려사항

### 권한 제한

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@anthropic-ai/mcp-server-filesystem",
        "--read-only",
        "./src"
      ]
    }
  }
}
```

### 환경 변수 관리

```json
{
  "mcpServers": {
    "database": {
      "command": "npx",
      "args": ["-y", "mcp-server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

**주의**: 민감한 정보는 환경 변수 참조를 사용하고, 직접 값을 설정 파일에 포함하지 마세요.

### 네트워크 제한

- 필요한 서버만 활성화
- 외부 네트워크 접근이 필요한 서버는 신중하게 검토
- 프로덕션 환경의 자격 증명 사용 금지

## 트러블슈팅

### 서버 연결 실패

1. 명령어 경로 확인
```bash
which npx
npx -y @anthropic-ai/mcp-server-filesystem --help
```

2. 로그 확인
```bash
# Claude Desktop 로그
tail -f ~/Library/Logs/Claude/mcp.log  # macOS
```

3. 권한 확인
```bash
ls -la /path/to/project
```

### 도구 호출 실패

1. 입력 스키마 검증
2. 환경 변수 설정 확인
3. 네트워크 연결 확인 (외부 API 사용 시)

## 참고 자료

- [MCP 공식 문서](https://modelcontextprotocol.io/)
- [MCP SDK GitHub](https://github.com/modelcontextprotocol)
- [공식 MCP 서버 목록](https://github.com/modelcontextprotocol/servers)
