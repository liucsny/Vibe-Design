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
2. Confirm Figma MCP is reachable.

## Steps

### 1. Enumerate Frames
Read `final-ui-reference.md` to get all frame IDs for the story.

### 2. Scan Each Frame
For each frame, use Figma MCP to read its node tree. Identify:
- The frame's surface name and state
- Key interactive and informational elements (inputs, buttons, tables, banners, empty states, modals)
- Assign semantic labels to each key element

### 3. Validate Node IDs
For every node ID you plan to record, verify it exists via a Figma MCP read call.
- If a node ID responds successfully → include it.
- If a node ID is missing or returns an error → do not include it. Log the gap.

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
