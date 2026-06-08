Check whether the required external tools are configured and guide the user through any missing setup.

## Check each tool

### 1. lark-cli
Run:
```bash
lark-cli --version
```
- ✅ Returns a version number → lark-cli is installed
- ❌ `command not found` → tell the user:
  > lark-cli is not installed. You need it to fetch PRDs from Feishu/Lark URLs.
  > Install: `npm install -g @larksuiteoapi/lark-cli`
  > Then authenticate: `lark-cli config init --new`
  > Full guide: `docs/setup.md §1`

Then check auth:
```bash
lark-cli auth status
```
- ✅ Shows active user → authenticated
- ❌ Not authenticated → tell the user to run `lark-cli config init --new`

### 2. Figma MCP
Attempt a minimal Figma MCP tool call (e.g., list available tools or ping the API).
- ✅ Responds → Figma MCP is active
- ❌ Tool not found or error → tell the user:
  > Figma MCP is not configured. You need it to generate Figma frames.
  > Setup steps: `docs/setup.md §2`
  > Quick summary:
  > 1. Get a Personal Access Token from Figma Settings → Security
  > 2. Add to your MCP config: `~/.claude/claude_desktop_config.json`
  > 3. Restart Claude Code

### 3. Figma target URL (for active task)
If a task is active (projects/ contains a task-state.json), check `figma.target_url`:
- ✅ Set → show the URL
- ❌ null → tell the user:
  > No Figma file URL is set for the active task.
  > Provide the URL of your Figma file (the one where frames should be created).
  > I will update task-state.json automatically.

## Summary output

After all checks, print a clear status table:

```
Tool         Status     Note
──────────   ────────   ──────────────────────────
lark-cli     ✅ ready   v1.x.x, authenticated as <user>
Figma MCP    ✅ ready   API reachable
Figma URL    ✅ set     https://figma.com/file/...
```

or show exactly what needs to be fixed, with the relevant section of `docs/setup.md`.
