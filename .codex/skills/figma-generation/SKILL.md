---
name: figma-generation
description: Build all Figma frames for a story via Figma MCP, following the UI delivery spec exactly. Records all frame IDs in final-ui-reference.md.
---

# Figma Generation

## Inputs
- `current/stories/<story-id>/ui-delivery-spec.md`
- `current/design-brief.md` (DS section)
- `current/task-state.json`

## Output
- Figma frames in the target file
- `current/stories/<story-id>/final-ui-reference.md`
- Updated `current/task-state.json` (story figma_generation → passing, figma_section_id set)
- `logs/04-figma-generation-<story-id>.md`

## Preflight

Run all checks before generating any frames. On any failure: set the stage to `blocked` in `task-state.json`, populate `blocked_input_request` with the message below, and stop.

### Check 1 — Delivery spec ready
Confirm story's `delivery_spec = passing`. If not: stop and tell the user to run `delivery-spec-writer` first.

### Check 2 — Figma MCP available
Attempt a minimal Figma MCP call (e.g., read the file metadata at `figma.target_url`, or list available MCP tools).

**If Figma MCP is not reachable**, set `blocked_input_request` to:

```
Figma MCP is not configured or not running.

To fix:
1. Get a Personal Access Token: Figma → Settings → Security → Personal access tokens
2. Add to your MCP config (~/.claude/claude_desktop_config.json or project .mcp.json):
   {
     "mcpServers": {
       "figma": {
         "command": "npx",
         "args": ["-y", "@figma/mcp-server"],
         "env": { "FIGMA_API_TOKEN": "your-token-here" }
       }
     }
   }
3. Restart Claude Code.
4. Re-run /figma-generator once Figma MCP is active.

Full guide: docs/setup.md §2
```

### Check 3 — Figma target URL set
Confirm `figma.target_url` is set in `task-state.json`.

**If null**, set `blocked_input_request` to:

```
No Figma file URL is configured for this task.

Please provide the URL of the Figma file where frames should be created.
Example: https://www.figma.com/file/XXXXXXXX/Your-File-Name

I will update task-state.json and continue automatically.
```

### Check 4 — Figma library subscribed (when DS adapter configured)
If `figma.library_adapter` is set: verify the library is subscribed in the target Figma file.

**If not subscribed**, set `blocked_input_request` to:

```
The design system library is not subscribed in your Figma file.

To fix:
1. Open your Figma file
2. Go to Assets panel (left sidebar) → Libraries icon
3. Find "<library-name>" and click "Add to file"
4. Re-run /figma-generator.
```

## Steps

### 1. Create Story Section
Create a named Section in the target Figma file: `<story-name> — <task-id>`.
Set Section background to `#E5E5E5`.
Record the Section node ID in task-state.json `stories[].figma_section_id`.

### 2. Generate Frames
For each surface in `ui-delivery-spec.md`, generate one frame per state.

Frame naming convention: `<Surface Name> / <State>` (e.g., `Algorithm Config / Default`, `Algorithm Config / Empty`).

For each frame:
- Set up primary Auto Layout container (direction, gap, padding as specified in the spec).
- Place components following the spec's "Key elements" and "Components" lists.
- When DS adapter is configured: import the component from the library using its key. Do not redraw library components with primitives.
- When no DS is configured: use local Auto Layout frames as component placeholders with descriptive layer names.
- Apply token values (colors, spacing, radius) from design-brief.md DS section if available.
- Label all layers semantically — no "Frame 1", "Group 2" layer names.

### 3. Organize in Section
Place all generated frames inside the Section created in Step 1.
Arrange frames in user flow order (left to right, or as logical reading order).
Add a Section title frame at the top: `<story-name>` in header text style.

### 4. Write final-ui-reference.md

```markdown
# Final UI Reference — <story-name>

## Story: <story-id>
Figma Section: <section-node-id>
Target file: <figma-target-url>

## Frames

| Surface | State | Frame ID | Figma Link |
|---|---|---|---|
| <surface-name> | default | <node-id> | <link> |
| <surface-name> | loading | <node-id> | <link> |
...

## Components Used
| Component | Library Key | Instances |
|---|---|---|
...

## Notes
<Any deviations from the spec and why>
<Any fallback components and reason>
```

### 5. Update task-state.json
- Set story's `figma_generation` to `passing`.
- Record `figma_section_id`.
- Append timeline entry.

### 6. Write Execution Log
Write `logs/04-figma-generation-<story-id>.md` using the standard log format. Include: how many frames generated, any blocked components, any spec deviations.
