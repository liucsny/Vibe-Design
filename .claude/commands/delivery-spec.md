Run the delivery-spec-writer stage for a story.

Arguments: $ARGUMENTS (optional: story-id, e.g. "s1" or "s2" — defaults to the first story with delivery_spec = not_started)

## Steps

1. Identify the task and story:
   - Parse $ARGUMENTS for a story-id (e.g. "s1").
   - If no story-id provided, read `task-state.json` and pick the first story where `stages.delivery_spec` is `not_started` or `active`.

2. Read `SOUL.md`.

3. Read `projects/<task-id>/current/task-state.json` — confirm `shared.context_scout = "passing"`.

4. Follow the skill: `.codex/skills/delivery-spec/SKILL.md`

The skill will read `design-brief.md` and the relevant PRD sections, then produce `current/stories/<story-id>/ui-delivery-spec.md`.
