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

### Step 1 — Install the Figma Remote MCP plugin

In your terminal:

```bash
claude plugin install figma@claude-plugins-official
```

### Step 2 — Restart Claude Code

MCP servers are loaded at startup. Restart Claude Code after running the install command.

### Step 3 — Authorize via browser

1. In Claude Code, type `/plugin` → navigate to the **Installed** tab
2. Select `figma` → press Enter to open the authorization page
3. Press Enter again to launch the browser auth flow
4. Click **Allow access** to grant Claude Code access to your Figma account

### Step 4 — Verify

Run `/plugin` again. Under the **Installed** tab, `figma` should show **connected**.

> **Note:** This uses Figma's official Remote MCP server (`https://mcp.figma.com/mcp`) with OAuth — no Personal Access Token required.

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
