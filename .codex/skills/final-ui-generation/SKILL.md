---
name: final-ui-generation
description: Generate final Vine UI drafts in Figma after upstream artifacts pass, or generate versioned UI revisions from revision-request.md.
---

# Final UI Generation

Generate Figma UI from the direct contract:
- first pass: `surface-generation-spec.md`
- revision mode: `revision-request.md`

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

## Write

Write:

```text
projects/<task-id>/current/final-ui-reference.md
projects/<task-id>/current/task-state.json
```

Include:
- Figma location
- generated surfaces / frames
- created frame ids
- revision id and revision frame ids, if applicable
- assumptions / known gaps
- QA target nodes or screenshots
- Context Delta
