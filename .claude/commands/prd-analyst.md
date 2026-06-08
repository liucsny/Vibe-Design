Run the prd-analyst stage for the active task.

Arguments: $ARGUMENTS (optional: task-id — if omitted, locate the active task automatically)

## Steps

1. Identify the task:
   - If $ARGUMENTS is provided, use it as the task-id.
   - Otherwise, find the most recently modified project under `projects/` where `task-state.json` has `shared.prd_analysis = "not_started"` or `"active"`.

2. Read `SOUL.md`.

3. Read `projects/<task-id>/current/task-state.json` — confirm `shared.prd_analysis` is `not_started` or `active`.

4. Follow the skill: `.codex/skills/prd-analysis/SKILL.md`

The skill will read `current/prd.md`, produce `current/prd-analysis.json`, and update `task-state.json`.
