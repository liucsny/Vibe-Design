Run the qa-reviewer stage for a story.

Arguments: $ARGUMENTS (optional: story-id — defaults to first story with qa_review = not_started)

## Steps

1. Identify the task and story (same logic as /delivery-spec).

2. Read `SOUL.md`.

3. Read `projects/<task-id>/current/task-state.json`:
   - Confirm `stories[].stages.figma_generation = "passing"` for the target story.

4. Follow the skill: `.codex/skills/qa-review/SKILL.md`

The skill will capture Figma screenshots, validate against `ui-delivery-spec.md` and the PRD, classify all issues with `cause_type`, and produce `current/stories/<story-id>/scenario-quality-check.md`.

QA passes only when `p0 = 0` AND `p1 = 0`.
