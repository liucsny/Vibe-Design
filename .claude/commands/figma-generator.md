Run the figma-generator stage for a story.

Arguments: $ARGUMENTS (optional: story-id — defaults to first story with figma_generation = not_started)

## Steps

1. Identify the task and story (same logic as /delivery-spec).

2. Read `SOUL.md`.

3. Read `projects/<task-id>/current/task-state.json`:
   - Confirm `stories[].stages.delivery_spec = "passing"` for the target story.
   - Check `figma.target_url` — if null, ask the user for the Figma file URL before proceeding.

4. Follow the skill: `.codex/skills/figma-generation/SKILL.md`

The skill will read `ui-delivery-spec.md` and generate all Figma frames via Figma MCP, then produce `current/stories/<story-id>/final-ui-reference.md`.
