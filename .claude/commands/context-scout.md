Run the context-scout stage for the active task.

Arguments: $ARGUMENTS (optional: task-id)

## Steps

1. Identify the task (same logic as /prd-analyst — use $ARGUMENTS or find the active task).

2. Read `SOUL.md`.

3. Read `projects/<task-id>/current/task-state.json` — confirm `shared.prd_analysis = "passing"` and `shared.context_scout` is `not_started` or `active`.

4. Follow the skill: `.codex/skills/context-scout/SKILL.md`

The skill will read `prd-analysis.json` and `.codex/design-systems/` (if configured), then produce `current/design-brief.md`.
