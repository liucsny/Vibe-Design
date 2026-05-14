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
If `design-system-reference.md` exists, use it as the active component/style contract. If `task-state.json.design_system.required` is true and the artifact is missing or not summarized, block Final UI.

Load Vine design skills only in this stage or later, and only when needed by the current surface:

```text
vine-design-context
vine-design-core
vine-design-tokens
vine-design-components
figma:figma-generate-design
figma:figma-use
```

For maintainability gates, load `references/structured-figma-gates.md` on demand. Do not inline or restate those rules in downstream prompts.

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

If `design_system.required` is true and `design_system.status` is not `summarized`:
- mark `final-ui` blocked
- set `blocked_reason: Missing summarized design system reference`
- populate `blocked_input_request` if the adapter source is missing or inaccessible
- run `design-system-reference` first when adapter files are available

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

## Structured Figma Build

Final UI must be maintainable in Figma. Do not generate final screens as flat rectangles and text nodes.

Before writing frames:
- read `design-system-reference.md`
- read the active adapter `registry.md`, `component-library-index.md`, and `component-selection-rules.md`
- read only the recipe files selected in `design-system-reference.md`
- load only task-relevant adapter details; do not load the full Figma library metadata dump
- inspect the target file and baseline frames for existing components, instances, variables, styles, and Auto Layout conventions
- use public design-system components or instances whenever available
- if no suitable component exists, create local reusable components or component-like structured frames for repeated controls and patterns
- follow the `Structured Figma Requirements` section from `surface-generation-spec.md`

Apply the Design System Gate and Structure Gate from `references/structured-figma-gates.md`.

A final UI that is mostly flat primitives is not passing. Route back or fix the Figma structure before Scenario / Quality Check.

## Text Resizing And Truncation

Every text node must use an intentional Figma resizing mode. Do not default all text to Auto height or Fixed size.

Apply the Text Gate from `references/structured-figma-gates.md`. After generation, inspect text metadata and screenshots; fix clipped text, wrong resize modes, missing truncation, or missing full-value reveal behavior before QA.

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
- structured Figma evidence:
  - active design system adapter id and source file key
  - adapter reference files loaded
  - recipe files loaded
  - public component families used, with component names and keys/node ids
  - internal components excluded or avoided
  - design system fallbacks, with reason and scope
  - existing components or instances reused
  - local components or component-like frames created
  - Auto Layout hierarchy by generated frame
  - per-frame direct child count, with any count over `8` fixed before QA
  - per-frame Auto Layout container count and names for required containers
  - repeated patterns and how each is reused
  - primitive exceptions with node id, reason, and scope
  - text sizing evidence by generated frame:
    - Auto width text count
    - Auto height text count
    - Fixed size text count
    - truncation-enabled text node ids and field names
    - overflow exceptions and full-value reveal behavior
  - metadata inspection summary
- generated surfaces / frames
- created frame ids
- revision id and revision frame ids, if applicable
- assumptions / known gaps
- QA target nodes or screenshots
- baseline frame/source ids and preserved areas, when applicable
- research-informed patterns used, when applicable
- Context Delta
