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
Call `whoami` to verify Figma MCP is reachable. Do NOT call `get_metadata` on the file URL here — it returns the entire file tree and can exceed token limits on large files.

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

## Figma MCP Precision Rules

These rules apply for the entire session. Violating them causes context bloat and token overruns.

### `whoami`
- Use only for connectivity checks. One call per session, at Preflight.

### `get_metadata`
- Always pass `node_id`. Never call without it.
- Use only for post-fix verification (Rework Rule 2). Do not call during generation — you already know the structure because you wrote it.
- One call per fixed node, not per frame or per session.

### `get_design_context`
- Always pass `node_id`. Never call on the file URL or without scoping.
- Use only when you need layout/style reference for a **specific complex component** you are about to build and whose structure is unclear from the spec alone.
- Maximum 1 call per frame. Do not call for every frame — only frames with genuinely ambiguous layout.

### `get_variable_defs`
- Call at most **once per session**, before generation starts (not mid-loop).
- Only call when `figma.library_adapter` is set in task-state.json. If no DS adapter, skip entirely.
- Store the result in memory for the session; do not re-call.

### `get_libraries`
- Call at most **once per session**, during Preflight Check 4 (library subscription verification).
- Only call when `figma.library_adapter` is set. If no DS adapter, skip entirely.

### `search_design_system`
- Batch all component lookups: identify every component family you need before generation starts, then run one search per family — not one search per component instance.
- Do not call inside the per-frame generation loop.

### `get_screenshot`
- Rework sessions only. Do not call during initial generation.
- Hard cap: **maximum 5 screenshots per rework session**, applied only to the specific frames being fixed.

### `use_figma`
- Batch all mutations for a given issue into one script. Do not issue one `use_figma` call per node.

---

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
After fixing each issue, call `get_metadata` with the specific `node_id` of the affected node to confirm the structural change took effect (e.g., width reduced, textAutoResize set).

**Where to get `node_id`**: The QA issue lists the node IDs touched (from `scenario-quality-check.md` "Evidence" field, or from the `use_figma` script you just ran). Use those IDs — do not look up the file URL.

Always pass `node_id` — never call `get_metadata` without it. Do not rely on the script returning no error — explicitly check the node's properties.

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
