---
name: ui-generation-spec
description: Create a concise Surface Generation Spec from a PRD, Flow Spec, and relevant artifacts before Final UI generation. In raw PRD-to-UI workflows, do not load product-specific design skills such as `vine-design-*`; capture product/design-system needs as generation requirements for the later Final UI stage.
---

# Surface Generation Spec

**Dual-Core Input Philosophy:**
- **Core Input 1 (Anchor):** The PRD. Use this for fidelity checks against the original product goals.
- **Core Input 2 (Contract):** The `flow-spec.md` artifact. This is your direct execution contract for task logic and interaction paths.
- **Auxiliary Inputs:** Use `task-state.json`, `design-system-reference.md`, `baseline-reference.md`, etc., as supporting context. DO NOT load older passing artifacts (like `intent-requirement.md`) unless there is a specific data gap blocking you.

Define what the Figma UI designer should create. Use the Flow Spec for task logic and the PRD for fidelity checks.

Do not load Vine design skills here. Record design-system needs for Final UI generation instead.

In revision mode, use `revision-request.md` only for routed surface-level changes. Preserve unchanged surfaces and clearly identify affected frames/states for versioned Final UI work.

If `baseline-reference.md` exists, include affected areas and do-not-change areas in the generation spec.
If `research-reference.md` exists, include relevant reference patterns and anti-patterns without copying product UI.
If `design-system-reference.md` exists, use it as the component/style contract and list task-relevant component families in `Structured Figma Requirements`.

## Output

Use this structure:

```text
# Surface Generation Spec

## Surfaces / Frames To Generate

## Surface Purpose And Priority

## Flow Grouping And Canvas Order
- flow group:
- user intent:
- frames / states included:
- order:

## Required Content Blocks

## Required States

## Primary / Secondary Actions

## Interaction And Review Rules

## Structured Figma Requirements
- imported public components:
- local component variants:
- Auto Layout containers:
- nesting hierarchy:
- direct child limit:
- repeated pattern threshold:
- text resizing rules:
- truncation rules:
- primitive exceptions:

## Design System Guidance
- adapter:
- required public component families:
- component import policy:
- internal components excluded:
- fallback families:
- adapter references to load:

## Baseline Preservation
- baseline frames/sources:
- reuse:
- do not change:
- new/versioned frames needed:

## Research-Informed Guidance
- patterns to consider:
- anti-patterns to avoid:
- terminology:

## References To Use

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

Keep this as generation context, not a final prompt artifact. It should be specific enough for `figma-ui-designer` to generate multiple UI drafts without reinterpreting the PRD.

## Structured Figma Contract

The Surface Generation Spec must define the maintainability contract that Final UI will be judged against.

Include only task-specific decisions:
- imported public component families and local fallback variants
- required Auto Layout regions and semantic nesting per major frame
- direct child limit, defaulting to `<= 8`
- repeated pattern threshold, defaulting to `2+ occurrences require component/component-like reuse`
- text resizing and truncation rules for task content that may overflow
- allowed primitive exceptions
- active adapter id, required public families, component import policy, excluded internal components, and fallback families

Public component import policy is mandatory:
- Required public component families must be imported and instantiated from the active Figma library.
- Do not specify local fallback variants for public families that exist in the adapter.
- Local fallback variants are allowed only for task-specific compositions missing from the adapter, and must compose imported public controls when they contain buttons, selects, inputs, tags, banners, modals, popovers, toasts, or tables.
- If the required public family cannot be imported, Final UI must block instead of drawing it.

Do not accept a Surface Generation Spec that only lists visual frames and content blocks. It must give the Final UI designer enough structural direction to avoid flat primitive-only Figma output.

Do not copy the full gate reference into this artifact. Final UI and QA load `.codex/skills/final-ui-generation/references/structured-figma-gates.md` when they need detailed rules.
