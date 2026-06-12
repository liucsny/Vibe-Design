---
name: design-map
description: Scan all story Figma frames and build design-map.json mapping design concepts to Figma node IDs. Required before Phase B can operate. Includes node ID validation.
---

# Design Map Builder

## Inputs
- `current/stories/<story-id>/final-ui-reference.md`
- Figma MCP (node scan)
- `current/task-state.json`

## Output
- `current/stories/<story-id>/design-map.json`
- Updated `current/task-state.json` (story design_map → passing)
- `logs/06-design-map-<story-id>.md`

## Preflight
1. Confirm story's `qa_review = passing`.
2. Confirm `quality_gate.p1 = 0`. If p1 > 0: set `design_map` to `blocked`, populate `blocked_input_request` with instructions to re-run figma-generator to resolve the P1(s) listed in `scenario-quality-check.md`, then re-run qa-reviewer, then retry design-map-builder. Stop.
3. Confirm Figma MCP is reachable via `whoami` — do NOT use `get_metadata` on the file URL for this check.
4. **Large tool-result guard**: If a Figma MCP response file exceeds 25K tokens, use `offset` + `limit` on the Read tool to extract the relevant section, or grep for the target `node_id` to find the byte offset first.

## Figma MCP Precision Rules

### `whoami`
- Use only for connectivity check. One call at Preflight, not repeated.

### `get_metadata`
- Always pass `node_id`. Never call on the file URL.
- One call per frame row from `final-ui-reference.md`. Do not call again for validation — see Step 3.

### `get_design_context`
- Always pass `node_id`. Never call without it.
- Use only when a frame's node tree (from `get_metadata`) is insufficient to identify a key element's semantic role — e.g., the element type is ambiguous from layer names alone.
- Maximum 1 call per ambiguous frame. Do not call for every frame.

### `get_variable_defs`
- Call at most **once per session**, only if `figma.library_adapter` is set.
- Only call if you need to resolve a token name to a node ID for the map. If token IDs are already in the node tree, skip.

### `get_libraries`
- Do not call in design-map unless required to resolve an unrecognized component origin. In normal operation this tool is not needed here.

### `get_screenshot`
- Do not call during design-map building. This stage is structural — no visual inspection needed.

---

## Steps

### 1. Enumerate Frames
Read `final-ui-reference.md` to get all frame IDs for the story.

### 2. Scan Each Frame
For each frame, call `get_metadata` with the specific `node_id` from `final-ui-reference.md` to read that frame's node tree.

**Where to get `node_id`**: The "Frame ID" column in `final-ui-reference.md` is the `node_id`. Use that value directly as the `node_id` parameter — one `get_metadata` call per row.

**Critical: Always pass `node_id`.** Never call `get_metadata` on the file URL alone — it returns the entire file tree and will exceed the 25K-token read limit on any non-trivial Figma file.

Identify:
- The frame's surface name and state
- Key interactive and informational elements (inputs, buttons, tables, banners, empty states, modals)
- Assign semantic labels to each key element

### 3. Validate Node IDs
For every node ID you plan to record, verify it exists by calling `get_metadata(node_id=X)` — pass the specific node ID, not the file URL.
- If the call responds successfully → include it.
- If the call returns an error or empty result → do not include it. Log the gap.
- Reuse the Step 2 `get_metadata` call where possible — if you already have the node tree for a frame, child node IDs visible in that tree do not need a separate validation call.

### 4. Build design-map.json

```json
{
  "meta": {
    "story_id": "",
    "last_validated": "",
    "figma_file_version": "",
    "stale_count": 0
  },
  "surfaces": {
    "<surface-kebab-name>": {
      "frame_id": "",
      "prd_section": "",
      "state": "default | loading | empty | error | <custom>",
      "stale": false,
      "last_verified": "",
      "elements": {
        "<semantic-label>": {
          "node_id": "",
          "stale": false
        }
      }
    }
  },
  "prd_to_frame_index": {
    "<prd-section-ref>": ["<frame-id>"]
  }
}
```

One entry per surface+state combination. The `prd_to_frame_index` maps PRD section references to frame IDs for quick lookup in Phase B.

### 5. Update task-state.json
- Set story's `design_map` to `passing`.
- Append timeline entry.

### 6. Write Execution Log
Write `logs/06-design-map-<story-id>.md`. Include: frames scanned, elements mapped, any node IDs skipped due to validation failure.

---

## Phase B: Map Maintenance Rules

These rules apply when re-invoking this skill during Phase B.

**Before any Hot Fix:**
- Re-read the map. Check `meta.stale_count`.
- For any entry with `stale: true`: re-scan the frame to get the current node ID, update the entry, set `stale: false`.
- Do not proceed with a Hot Fix if the target element has `stale: true` and cannot be resolved.

**After a Hot Fix that creates new nodes:**
- Add the new node IDs to the map.
- Set `meta.last_validated` to now.

**After a Surface or Escalate path rebuilds a frame:**
- Mark all entries for the rebuilt surfaces: `stale: true`.
- After QA passes on the rebuilt frames, re-run Steps 2–4 for affected surfaces only.
- Set rebuilt entries back to `stale: false`.
