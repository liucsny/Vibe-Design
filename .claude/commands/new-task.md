Initialize a new Vibe Design task from a PRD, then start Phase A.

Arguments: $ARGUMENTS

## Step 1 — Initialize the task

Determine the PRD source from $ARGUMENTS:

- **Lark/Feishu URL** (contains `larkoffice.com` or `feishu.cn`):
  ```bash
  scripts/init-task-from-prd.sh --lark-url "$ARGUMENTS" --title "<short-english-title>"
  ```
- **Local file path** (ends in `.md`, `.txt`, or is a file path):
  ```bash
  scripts/init-task-from-prd.sh --file "$ARGUMENTS" --title "<short-english-title>"
  ```
- **No argument / PRD pasted in chat**: ask the user to paste the PRD text or provide a URL.
  Then: `scripts/init-task-from-prd.sh --text "<prd-text>" --title "<short-english-title>"`

If no title is available, derive a short kebab-case English title from the PRD's first meaningful line and pass it via `--title`.

## Step 2 — Start Phase A

After initialization succeeds:
1. Note the `TASK_ID` printed by the script.
2. Read `SOUL.md`.
3. Read `projects/<task-id>/current/task-state.json`.
4. Immediately proceed with the `prd-analyst` stage — follow `.codex/skills/prd-analysis/SKILL.md`.
