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
  > Full guide: `rules/setup.md §1`

Then check auth:
```bash
lark-cli auth status
```
- ✅ Shows active user → authenticated
- ❌ Not authenticated → tell the user to run `lark-cli config init --new`

### 2. Figma MCP — connectivity
Attempt `whoami` or any read-only Figma MCP call.
- ✅ Responds → Figma MCP is active, proceed to check 2b.
- ❌ Tool not found or error → tell the user:
  > Figma MCP is not configured. You need it to generate Figma frames.
  > Setup steps: `rules/setup.md §2`
  > Quick summary:
  > 1. Run: `claude plugin install figma@claude-plugins-official`
  > 2. Restart Claude Code
  > 3. Type `/plugin` → Installed → select figma → authorize in browser

### 2b. Figma MCP — write access
If `figma.target_url` is set in the active task, attempt a minimal `use_figma` call on that file.
- ✅ Succeeds → write access confirmed.
- ❌ Permission error / 403 → tell the user:
  > ⚠️ Figma 文件无写入权限。figma-generator 将无法创建 frames。
  > 请在 Figma 中将自己的权限改为 **Can edit**（Share → 修改权限）。
- ❌ No target URL set → skip this check (handled in check 3 below).

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

or show exactly what needs to be fixed, with the relevant section of `rules/setup.md`.
