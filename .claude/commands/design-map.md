Run the design-map-builder stage for a story.

Arguments: $ARGUMENTS (optional: story-id — defaults to first story with design_map = not_started)

## Steps

1. Identify the task and story (same logic as /delivery-spec).

2. Read `SOUL.md`.

3. Read `projects/<task-id>/current/task-state.json`:
   - Confirm `stories[].stages.qa_review = "passing"` for the target story.

4. Follow the skill: `.codex/skills/design-map/SKILL.md`

The skill will scan all Figma frames for the story, validate every node ID via Figma API, and produce `current/stories/<story-id>/design-map.json`.

After design-map passes for all stories: run Cross-Story Consistency Check, then create `milestones/v0/` snapshot (copy `current/` → `milestones/v0/`).
