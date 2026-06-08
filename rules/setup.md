# Vibe Design — Tool Setup Guide

This guide covers the two external tools required to run the full workflow. Both are optional depending on how you use the system — see the table below.

| Tool | Required for | Skip if |
|---|---|---|
| **lark-cli** | Fetching PRDs from Feishu/Lark via `--lark-url` | You always paste PRD text or use `--file` |
| **Figma MCP** | `figma-generator` and `design-map-builder` stages | You only run up to `delivery-spec` |

---

## 1. lark-cli

lark-cli lets the init script fetch a PRD document directly from a Feishu/Lark URL.

### Install

```bash
# Check if already installed
lark-cli --version

# Install (requires Node.js 18+)
npm install -g @larksuiteoapi/lark-cli
```

### Configure

```bash
lark-cli config init --new
```

This opens a browser auth flow. Follow the prompts to connect your Feishu account.

### Verify

```bash
lark-cli docs +fetch --api-version v2 \
  --doc "https://bytedance.larkoffice.com/docx/<any-doc-id>" \
  --scope outline
```

You should see a JSON response with `"ok": true`.

### Troubleshooting

| Error | Fix |
|---|---|
| `lark-cli: command not found` | Re-run `npm install -g @larksuiteoapi/lark-cli` |
| `permission_violations` in response | Run `lark-cli auth login --scope "docx:document:readonly"` |
| Auth expired | Run `lark-cli auth login --domain bytedance` |

Full setup guide (internal): https://bytedance.larkoffice.com/docx/PxZadXlz2o4mCmxjAvfc30H3nQg

---

## 2. Figma MCP

Figma MCP lets `figma-generator` and `design-map-builder` create and read Figma frames via the Figma REST API.

### Step 1 — Get a Figma Personal Access Token

1. Open Figma → click your avatar (top-left) → **Settings**
2. Scroll to **Security** → **Personal access tokens**
3. Click **Generate new token**, give it a name (e.g. `vibe-design`), set expiry
4. **Copy the token immediately** — it won't be shown again

### Step 2 — Add MCP Server to Claude Code

Add the following to your Claude Code MCP config (`~/.claude/claude_desktop_config.json` or the project's `.mcp.json`):

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@figma/mcp-server"],
      "env": {
        "FIGMA_API_TOKEN": "your-token-here"
      }
    }
  }
}
```

Replace `your-token-here` with the token from Step 1.

> **Security note:** Never commit this token to git. If you use a project-level `.mcp.json`, add it to `.gitignore`.

### Step 3 — Restart Claude Code

MCP servers are loaded at startup. Restart Claude Code after editing the config.

### Step 4 — Set the Figma target URL

When running `figma-generator`, the agent needs to know which Figma file to write to. Either:

- Set it in `task-state.json` before running:
  ```json
  "figma": {
    "target_url": "https://www.figma.com/file/XXXXXXXX/Your-File-Name"
  }
  ```
- Or simply tell the agent the URL in chat — it will update `task-state.json` automatically.

### Verify

In a Claude Code session, check that the Figma MCP tool is available:

```
/setup
```

The setup command will report which tools are active.

### Troubleshooting

| Error | Fix |
|---|---|
| `figma MCP tool not found` | Check the MCP config JSON is valid, then restart Claude Code |
| `401 Unauthorized` | Token expired or incorrect — generate a new token in Figma Settings |
| `403 Forbidden` | The token doesn't have access to the target file — check file permissions |
| `figma.target_url is null` | Set the Figma file URL in `task-state.json` or tell the agent in chat |

---

## 3. Quick Verification Checklist

Run `/setup` in Claude Code to get an automated status check. Or verify manually:

```bash
# 1. lark-cli installed?
lark-cli --version

# 2. lark-cli authenticated?
lark-cli auth status

# 3. Figma MCP configured?
# Check your MCP config file:
cat ~/.claude/claude_desktop_config.json | grep -A5 figma
```

---

## 4. Running Without External Tools

If you want to test the pipeline without lark-cli or Figma MCP:

- **PRD source**: use `--text` or `--file` instead of `--lark-url`
- **Figma generation**: the `figma-generator` stage will block with a clear message — you can still run all stages up to `delivery-spec` and review the spec output
- **Design map**: also requires Figma MCP — skip if only validating the spec pipeline
