---
name: scenario-quality-check
description: Validate generated or revised Vine UI against PRD, screenshots, and realistic user scenarios.
---

# Scenario / Quality Check

Inspect screenshots for generated or changed frames. Do not pass from metadata alone.
Also inspect Figma metadata or use Figma Plugin API reads for node-tree maintainability. Do not pass from screenshots alone.

Load `../final-ui-generation/references/structured-figma-gates.md` only when validating Final UI structure, design-system evidence, or text overflow. Treat that file as the single source for detailed P1 gate rules.

## Checks

- requirement coverage
- scenario completion
- PM handoff clarity
- visual integrity
- Figma canvas assembly: Section exists, Section background is `#E5E5E5`, Section title frame exists, flow title frames exist, frames are ordered by user flow, and the Section contains all generated content with `300px` padding
- structured Figma maintainability: primary frames use Auto Layout for major containers, repeated controls are component instances or reusable local component/component-like frames, semantic nesting exists, and flat primitive-only construction is avoided
- hard structural thresholds: each generated screen has `8` or fewer direct child nodes, required semantic containers exist, required containers use Auto Layout, repeated patterns appearing `2` or more times are reusable, and primitive exceptions are documented with node ids
- text sizing and overflow: each text node uses an intentional Figma resizing mode, overflow-prone fixed-width text uses truncation, multi-line fixed-height text has a maximum line/overflow strategy, and truncated decision-critical values expose their full value
- design system adherence: active adapter is recorded, public task-relevant components are used, internal components are not used directly, and fallback components have reasons
- component semantics
- copy quality
- adoption risk
- baseline drift, when a baseline exists
- fit to research-informed patterns, when research exists

## Severity

```text
P0: missing required surface/flow, impossible scenario, unreadable/broken layout
P1: misleading semantics, unclear state, materially incomplete required copy, canvas assembly that blocks review, or structured Figma maintainability failure
P2: minor spacing, hierarchy, density, copy polish, or canvas assembly mismatch that does not block review
```

Canvas assembly blocks review when the Section is missing, required title frames are missing, generated frames are not arranged by user flow, or the Section does not contain all generated content.

Structured Figma maintainability blocks review when a generated screen is mostly loose primitive nodes, key repeated controls are not reusable, major containers do not use Auto Layout, required evidence is missing, or text overflow is unsafe. Treat detailed failures listed in `structured-figma-gates.md` as P1 and route to `final-ui`; if the Surface Generation Spec did not define structure expectations, route to `surface-generation-spec`.

P0/P1 blocks delivery and routes to the owning stage:

```text
requirement -> intent-requirement
flow -> flow-spec
missing surface/state/frame -> surface-generation-spec
visual/UI -> final-ui
```

## Revision Mode

When `revision.status == active`:
- read `revision-request.md`
- screenshot changed/versioned frames
- test affected scenarios
- lightly regress the primary PRD flow
- set `revision.status: ready_for_review` only when P0/P1 = 0

## Output

```text
# Scenario / Quality Check

## Scenario Tested
- Scenario:
- Frame/screenshot:
- Result:

## Revision Tested
- revision:
- affected frames:
- affected scenarios:
- regression check:

## Issues
- Severity:
- Evidence:
- Impact:
- Fix:

## Loopback Target

## Required Changes

## Recheck
- Screenshots captured:
- Metadata / node-tree inspected:
- Direct child counts by frame:
- Auto Layout containers by frame:
- Repeated pattern reuse:
- Primitive exceptions reviewed:
- Design system adapter:
- Public components used:
- Internal components excluded:
- Fallback components reviewed:
- TextAutoResize counts by frame:
- Truncation-enabled text nodes:
- Text overflow / clipping review:
- Fixes applied:
- Recheck result:
- P0/P1 remaining:

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```
