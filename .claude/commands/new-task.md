Initialize a new Vibe Design task from a PRD, then hand off to the prd-analyst subagent.

Arguments: $ARGUMENTS

## Step 0 — Pre-flight check

Run the following checks **before doing anything else**:

### lark-cli (required when input is a Lark/Feishu URL)

If `$ARGUMENTS` contains `larkoffice.com` or `feishu.cn`:

```bash
lark-cli --version
```

- ❌ `command not found` → tell the user:
  > lark-cli 未安装，无法拉取飞书文档。请先完成安装：
  > ```
  > npm install -g @larksuiteoapi/lark-cli
  > lark-cli config init --new
  > ```
  > 详细步骤：`rules/setup.md §1`

  **Stop here. Do not proceed to Step 1.**

- ✅ Installed → also check auth:
  ```bash
  lark-cli auth status
  ```
  - ❌ Not authenticated → tell the user to run `lark-cli config init --new`, then **stop**.
  - ✅ Authenticated → continue to Step 1.

### Figma MCP (required for the full pipeline)

**Check 1 — connectivity**: attempt `whoami` or any read-only Figma MCP call.

- ❌ Not available → tell the user and **wait for their decision**:
  > ⚠️ **Figma MCP 未配置**。流程可以继续，但会在 `figma-generator` 阶段阻塞。
  > 建议现在配置：
  > ```
  > claude plugin install figma@claude-plugins-official
  > ```
  > 安装后重启 Claude Code，然后输入 `/plugin` → Installed → 选 figma → 浏览器授权。
  >
  > 输入「已配置」继续，或「跳过」先推进到 delivery-spec 阶段。

  - User replies "已配置" / "configured" / "done" → re-check, then continue.
  - User replies "跳过" / "skip" / "继续" → continue with a note that figma-generator will block later.

- ✅ Reachable → proceed to Check 2.

**Check 2 — write access**: if a Figma file URL was provided (Step 2.5), attempt a minimal `use_figma` call on that file.

- ❌ Permission error / 403 → tell the user and **wait for their confirmation**:
  > ⚠️ **Figma 文件无写入权限**。`figma-generator` 将无法在该文件中创建 frames。
  > 请在 Figma 中将自己的权限改为 **Can edit**（Share → 修改权限），完成后告知我。

  Wait for user to confirm, then re-check and continue.

- ✅ Write access confirmed → continue silently.

---

## Step 1 — Determine PRD source

- **Lark/Feishu URL** (contains `larkoffice.com` or `feishu.cn`) → go to Step 2
- **Local file path** → skip to Step 3, use `--file`
- **No argument / PRD pasted in chat** → ask the user to paste the PRD or provide a URL, then skip to Step 3 with `--text`

## Step 2 — Fetch title and confirm (Lark URLs only)

```bash
lark-cli docs +fetch --api-version v2 \
  --doc "$ARGUMENTS" \
  --scope outline --max-depth 1 \
  --doc-format markdown --format json
```

Extract the document title. Show the user:
> 📄 **「<title>」**
> `<url>`
> 确认使用该文档初始化任务吗？

**Wait for confirmation.**

## Step 2.5 — Collect Figma file URL

> 🎨 **请提供 Figma 文件链接**（frames 将在该文件中创建）：
> 例如：`https://www.figma.com/file/XXXXXXXX/Your-File-Name`
> 如暂时没有，直接回复「跳过」。

**Wait for reply.**

## Step 3 — Initialize the task

```bash
scripts/init-task-from-prd.sh --lark-url "<url>" --title "<short-english-title>" [--figma-url "<url>"]
```

Note the `TASK_ID` from the output.

## Step 4 — Hand off to prd-analyst subagent

After initialization succeeds, say:

> ✅ 任务已初始化：`<task-id>`
>
> 正在启动 prd-analyst…

Then invoke: **@agent-prd-analyst**

The subagent will run in an isolated context window, read only what it needs, and write `prd-analysis.json`.
