---
name: final-ui-generation
description: Generate final Vine UI drafts in Figma after upstream artifacts pass, or generate versioned UI revisions from revision-request.md.
---

# Final UI Generation

Generate Figma UI from the direct contract:
- first pass: `surface-generation-spec.md`
- revision mode: `revision-request.md`

If `baseline-reference.md` exists, use it as preservation context and avoid reloading raw baseline sources unless needed.
If `research-reference.md` exists, use it as pattern context without copying reference products.

Load Vine design skills only in this stage or later:

```text
vine-design-context
vine-design-core
vine-design-tokens
vine-design-components
figma:figma-generate-design
figma:figma-use
```

## Blockers

If `figma.target_url` is missing:
- mark `final-ui` blocked
- set `blocked_reason: Missing target Figma file URL`
- populate `blocked_input_request` for `figma.target_url`
- ask a concise form-style prompt

If Figma MCP is unavailable:
- mark `final-ui` blocked
- set `figma.mcp_status: not_configured`
- ask the user to configure Figma MCP/OAuth

## Revision Mode

When `revision.status == active`:
- use `revision-request.md` as the execution contract
- create versioned replacement frames by default
- preserve unchanged frames
- record `revision.created_frame_ids`
- record `revision.superseded_frame_ids`
- route back if the request needs upstream requirement/flow/surface work

## Figma Canvas Assembly

Before creating or revising final UI frames:
- If no target Section exists, create one by default.
- Use Section background `#E5E5E5`.
- Place all generated title frames, flow title frames, and UI frames inside the Section.
- Arrange generated UI frames according to the user logic and interaction flow from `surface-generation-spec.md`.
- Begin generated UI frame names with the project name, then the surface/state name.
- Add one Section title frame inside the Section:
  - background `#4274E4`
  - white title text
  - text size `64px`
  - horizontal padding `48px`
  - vertical padding `36px`
- Add one explanatory flow title frame before each flow group:
  - background `#4274E4`
  - white title text
  - text size `40px`
  - horizontal padding `48px`
  - vertical padding `24px`
- Resize the Section after all content is placed so it contains every generated item with `300px` padding on the top, right, bottom, and left.

Record the Section id, Section title frame id, flow title frame ids, frame order, and padding confirmation in `final-ui-reference.md` and `task-state.json`.

## Write

Write:

```text
projects/<task-id>/current/final-ui-reference.md
projects/<task-id>/current/task-state.json
```

Include:
- Figma location
- Section id / name
- Section title frame id
- flow groups and flow title frame ids
- frame arrangement order
- Section padding confirmation
- generated surfaces / frames
- created frame ids
- revision id and revision frame ids, if applicable
- assumptions / known gaps
- QA target nodes or screenshots
- baseline frame/source ids and preserved areas, when applicable
- research-informed patterns used, when applicable
- Context Delta
