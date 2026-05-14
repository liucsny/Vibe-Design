---
name: ui-generation-spec
description: Create a concise Surface Generation Spec from a PRD, Flow Spec, and relevant artifacts before Final UI generation. In raw PRD-to-UI workflows, do not load product-specific design skills such as `vine-design-*`; capture product/design-system needs as generation requirements for the later Final UI stage.
---

# Surface Generation Spec

Define what the Figma UI designer should create. Use the Flow Spec for task logic and the PRD for fidelity checks.

Do not load Vine design skills here. Record design-system needs for Final UI generation instead.

In revision mode, use `revision-request.md` only for routed surface-level changes. Preserve unchanged surfaces and clearly identify affected frames/states for versioned Final UI work.

## Output

Use this structure:

```text
# Surface Generation Spec

## Surfaces / Frames To Generate

## Surface Purpose And Priority

## Required Content Blocks

## Required States

## Primary / Secondary Actions

## Interaction And Review Rules

## Design System Guidance

## References To Use

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

Keep this as generation context, not a final prompt artifact. It should be specific enough for `figma-ui-designer` to generate multiple UI drafts without reinterpreting the PRD.
