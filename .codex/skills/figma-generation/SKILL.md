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
1. Run: claude plugin install figma@claude-plugins-official
2. Restart Claude Code.
3. Type /plugin → Installed → select figma → authorize in browser.

Full guide: rules/setup.md §2
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

### 2. Read Navigation Map
Before generating any frames, read the `## Navigation Map` section in `ui-delivery-spec.md`.

- Extract the happy path order from the flow graph (surfaces marked `★`).
- Note error recovery paths (marked `⚠`) — these frames should be grouped near their trigger surface.
- Note any multi-step loops — frames in a loop should be placed adjacent to each other.

This order determines how frames are arranged in Step 3.

If no Navigation Map is present in the spec, stop and log a warning: "Navigation Map missing from delivery spec — frame order will be arbitrary. Re-run delivery-spec-writer to add a Navigation Map."

### 3. Generate Frames
For each surface in `ui-delivery-spec.md`, generate one frame per state.

Frame naming convention: `<Surface Name> / <State>` (e.g., `Algorithm Config / Default`, `Algorithm Config / Empty`).

For each frame:
- Set up primary Auto Layout container (direction, gap, padding as specified in the spec).
- Place components following the spec's "Key elements" and "Components" lists.
- When DS adapter is configured: import the component from the library using its key. Do not redraw library components with primitives.
- When no DS is configured: use local Auto Layout frames as component placeholders with descriptive layer names.
- Apply token values (colors, spacing, radius) from design-brief.md DS section if available.
- Label all layers semantically — no "Frame 1", "Group 2" layer names.

### 4. Organize in Section
Place all generated frames inside the Section created in Step 1.

**Arrange frames following the Navigation Map order:**
- Happy path surfaces (★) run left to right as the primary row.
- Error and recovery frames are placed directly below their trigger surface (not at the end of the canvas).
- Multi-step loop frames are grouped in a visually distinct cluster.
- Surfaces not on the main flow are placed in a secondary row below.

Add a Section title frame at the top: `<story-name>` in header text style.

### 5. Write final-ui-reference.md

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

### 6. Update task-state.json
- Set story's `figma_generation` to `passing`.
- Record `figma_section_id`.
- Append timeline entry.

### 7. Write Execution Log
Write `logs/04-figma-generation-<story-id>.md` using the standard log format. Include: how many frames generated, frame arrangement rationale from Navigation Map, any blocked components, any spec deviations.

---

## QA Rework Rules

When re-running to fix QA issues, follow these rules to avoid repeated rework cycles:

### Rule 1 — Sibling State Propagation (mandatory)
For every issue fixed on a node, immediately scan **all other states of the same surface** for the identical defect pattern before marking the fix complete.

Example: if node X in the "Default" state has a text overflow, check every other state frame (Loading, Error, Validation Error, etc.) of that same surface for text overflow in the same relative position. Fix all occurrences in a single pass.

Never close a fix until you have verified no sibling state has the same defect.

### Rule 2 — Fix Verification Before Moving On
After fixing each issue, call `get_metadata` on the affected node to confirm the structural change took effect (e.g., width reduced, textAutoResize set). Do not rely on the script returning no error — explicitly check the node's properties.

### Rule 3 — Minimal Scope, Maximum Coverage
- Only touch nodes explicitly named in QA issues or identified as siblings by Rule 1.
- Do not regenerate entire frames or sections to fix a single node property.
- One `use_figma` call should handle all sibling fixes for a given issue type (e.g., fix all text overflow instances in one script).

### Rule 4 — Rework Summary
After all fixes, return a structured summary:
```
Fixed: [issue ID] — [node IDs touched] — [what changed]
Sibling check: [surface name] — [states checked] — [additional nodes fixed / none found]
```
