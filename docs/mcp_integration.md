# MCP Integration Guide

## Overview

NeuroLearn AI uses Model Context Protocol (MCP) servers to enhance development capabilities. This document outlines the configured MCP servers and how to use them effectively.

## Configured MCP Servers

### Context7 MCP Server

**Purpose**: Provides up-to-date code documentation for libraries and frameworks used in NeuroLearn AI.

**Repository**: [https://github.com/upstash/context7](https://github.com/upstash/context7)

**Configuration Location**: `~/.cursor/mcp.json`

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

## Available Tools

Context7 provides the following tools for AI-assisted development:

### 1. `resolve-library-id`
Resolves a general library name into a Context7-compatible library ID.

**Parameters**:
- `libraryName` (required): The name of the library to search for

### 2. `get-library-docs`
Fetches comprehensive documentation for a library using a Context7-compatible library ID.

**Parameters**:
- `context7CompatibleLibraryID` (required): Exact Context7-compatible library ID
- `topic` (optional): Focus the docs on a specific topic
- `tokens` (optional, default 10000): Maximum number of tokens to return

## Benefits for NeuroLearn AI Development

### Flutter/Dart Documentation
- Real-time access to Flutter widget documentation
- State management patterns and best practices
- Platform-specific implementations

### Backend Libraries
- Python FastAPI documentation
- LangChain integration patterns
- Mistral AI API documentation

### AI/ML Libraries
- Google ML Kit documentation for emotion detection
- TensorFlow integration patterns
- Computer vision APIs

## Setup and Usage

The MCP configuration has been automatically set up. To use Context7:

1. Open Cursor IDE
2. Use the AI chat panel
3. Ask questions like: "Get Flutter documentation for AnimatedContainer"
4. The AI will automatically fetch up-to-date documentation

## Troubleshooting

If you encounter issues, try these alternative configurations:

### Use bunx instead of npx:
```json
{
  "mcpServers": {
    "context7": {
      "command": "bunx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### For ESM resolution issues:
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "--node-options=--experimental-vm-modules", "@upstash/context7-mcp@latest"]
    }
  }
}
```

Ensure you have Node.js v18 or higher installed for best compatibility.

## Best Practices

### 1. **Specific Queries**
Instead of: "Get React documentation"
Use: "Get React documentation focused on hooks and state management"

### 2. **Library ID Resolution**
Always resolve library IDs first for accurate documentation:
```
1. Resolve library ID for "flutter"
2. Get Flutter documentation using the resolved ID
```

### 3. **Token Management**
For large documentation requests, specify token limits:
```
Get Flutter documentation with 15000 tokens focused on "widgets and layouts"
```

### 4. **Topic Focus**
Use specific topics to get relevant documentation:
- "accessibility" for inclusive design
- "performance" for optimization
- "testing" for quality assurance
- "state management" for architecture patterns

## Integration with NeuroLearn AI Features

### Emotion Engine
- Google ML Kit Face Detection API
- Camera integration patterns
- Real-time processing optimization

### Story Generation
- LangChain documentation for prompt engineering
- Mistral AI integration patterns
- Streaming response handling

### Communication Tools
- Accessibility APIs and best practices
- Speech synthesis and recognition
- Text-to-speech implementations

### Analytics Dashboard
- Chart.js or similar visualization libraries
- Data processing and aggregation patterns
- Real-time updates and WebSocket integration

## Future Enhancements

1. **Custom MCP Servers**: Consider creating project-specific MCP servers for:
   - NeuroLearn AI internal documentation
   - Research paper summaries
   - Neurodivergence support guidelines

2. **Documentation Automation**: Use Context7 to automatically update code comments and documentation

3. **Learning Resources**: Integrate educational content delivery through MCP

## Support and Resources

- **Context7 GitHub**: [https://github.com/upstash/context7](https://github.com/upstash/context7)
- **MCP Documentation**: Model Context Protocol specifications
- **NeuroLearn AI Development Guide**: `DEVELOPMENT_GUIDE.md`

---

*This MCP integration enhances NeuroLearn AI development by providing instant access to up-to-date documentation, enabling more efficient and informed coding decisions.* 