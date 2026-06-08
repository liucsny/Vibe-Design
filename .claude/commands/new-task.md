Initialize a new Vibe Design task from a PRD, then hand off to the prd-analyst subagent.

Arguments: $ARGUMENTS

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
