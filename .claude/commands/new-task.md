Initialize a new Vibe Design task from a PRD, then start Phase A.

Arguments: $ARGUMENTS

## Step 1 — Determine PRD source

- **Lark/Feishu URL** (contains `larkoffice.com` or `feishu.cn`) → go to Step 2
- **Local file path** → skip to Step 3, use `--file`
- **No argument / PRD pasted in chat** → ask the user to paste the PRD or provide a URL, then skip to Step 3 with `--text`

## Step 2 — Fetch title and confirm (Lark URLs only)

Run a lightweight fetch to get the document title:

```bash
lark-cli docs +fetch --api-version v2 \
  --doc "$ARGUMENTS" \
  --scope outline --max-depth 1 \
  --doc-format markdown --format json
```

Extract the document title from the response (first heading in the outline).

Show the user:
> 📄 **飞书文档标题：「<title>」**
> `<url>`
>
> 确认使用该文档初始化任务吗？

**Wait for the user's explicit confirmation before proceeding.**

- User confirms → continue to Step 3 with `--yes` flag
- User says no / provides a different URL → go back to Step 2 with the new URL
- lark-cli not found → show setup instructions from `docs/setup.md §1` and stop

## Step 2.5 — Collect Figma file URL

Ask the user in chat:

> 🎨 **请提供 Figma 文件链接**（frames 将在该文件中创建）：
> 例如：`https://www.figma.com/file/XXXXXXXX/Your-File-Name`
>
> 如暂时没有，直接回复"跳过"即可，稍后通过 `/setup` 设置。

**Wait for the user's reply.**

- User provides a URL → pass it via `--figma-url "<url>"` in Step 3
- User says skip / no URL → omit `--figma-url` from Step 3 (the script will leave `figma.target_url` as null)

## Step 3 — Initialize the task

```bash
# Lark URL (after confirmation + Figma URL collected)
scripts/init-task-from-prd.sh --lark-url "<url>" --title "<short-english-title>" --yes --figma-url "<figma-url>"

# Local file
scripts/init-task-from-prd.sh --file "$ARGUMENTS" --title "<short-english-title>" --figma-url "<figma-url>"

# Pasted text
scripts/init-task-from-prd.sh --text "<prd-text>" --title "<short-english-title>" --figma-url "<figma-url>"
```

Omit `--figma-url` if the user skipped that step.

If no title is available, derive a short kebab-case English title from the document title obtained in Step 2 (or the PRD's first meaningful line), and pass it via `--title`.

## Step 4 — Start Phase A

After initialization succeeds:
1. Note the `TASK_ID` printed by the script.
2. Read `SOUL.md`.
3. Read `projects/<task-id>/current/task-state.json`.
4. Immediately proceed with the `prd-analyst` stage — follow `.codex/skills/prd-analysis/SKILL.md`.
