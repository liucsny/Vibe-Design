---
name: qa-review
description: Validate Figma output against the delivery spec and PRD. Classify all issues with severity and cause_type. Gate delivery — p0+p1 must be zero to pass.
---

# QA Review

## Inputs
- `current/stories/<story-id>/ui-delivery-spec.md`
- `current/prd.md` (story sections)
- `current/stories/<story-id>/final-ui-reference.md`
- Figma screenshots of all story frames (capture via Figma MCP)
- `current/task-state.json`

## Output
- `current/stories/<story-id>/scenario-quality-check.md`
- Updated `current/task-state.json` (quality_gate counts, story qa_review status)
- `logs/05-qa-review-<story-id>.md`

## Preflight
1. Confirm story's `figma_generation = passing`.
2. Read `final-ui-reference.md` to get all frame IDs.
3. **Use a metadata-first, screenshot-on-demand strategy** (see Inspection Protocol below).

## Inspection Protocol — Metadata First, Screenshot on Demand

**Do NOT screenshot all frames upfront.** Screenshots are expensive. Use the following two-phase approach:

### Phase 1 — Structural scan (metadata only)
For each frame in `final-ui-reference.md`, call `get_metadata` to retrieve the node tree.
From metadata alone, check:
- Frame exists and is inside the correct Section
- Expected child count and layer hierarchy (e.g., modal has header / body / footer)
- Text node widths vs. container widths (overflow detection without screenshot)
- Auto Layout is set on primary containers
- Semantic layer names (not "Frame 1", "Group 2")
- Required child nodes are present (e.g., button labels, field labels, error text nodes)

Flag any frame that has a **structural anomaly** (unexpected node count, text wider than container, missing required child, flat non-AutoLayout hierarchy).

### Phase 2 — Targeted screenshot (flagged frames only)
Only call `get_screenshot` on frames flagged in Phase 1, plus:
- One representative frame per surface (to verify visual rendering)
- Any frame where the spec describes a visual-only requirement (colors, diff highlights, skeleton animation)

**Goal: screenshot at most 30–40% of frames**, not all of them.

### Efficiency rule
If a surface has 5 states and Phase 1 finds no structural anomaly in any of them, take 1 screenshot of the Default state only. Do not screenshot Loading, Error, and other states unless metadata raises a flag.

## Checks

Run all checks. Record every failing item as an Issue.

### Coverage
- Every surface listed in `ui-delivery-spec.md` exists as a Figma frame.
- Every required state for each surface is present.
- All PRD functional requirements have a corresponding UI surface or element.

### Structure
- Primary containers use Auto Layout.
- Repeated controls (appearing 2+ times) are component instances or reusable local frames, not duplicated primitives.
- Each frame has 8 or fewer direct child nodes (semantic grouping, not flat primitives).
- Frames use semantic layer names.

### Design System (when adapter configured)
- Required components are imported from the library, not redrawn.
- No internal (underscore-prefixed) components are used.
- Fallback components are documented with reason in `final-ui-reference.md`.

### Copy and Content
- All visible text matches PRD copy or is reasonable placeholder with correct information structure.
- No untranslated template strings (e.g., `{{variable_name}}`, `[placeholder]`).
- Error messages follow the pattern defined in design-brief.md.

### Visual Integrity
- No text overflow or clipping visible in screenshots.
- Color usage is consistent with design brief tokens.
- Spacing is consistent across similar elements.

## Severity Classification

**P0 (delivery blocker):**
- Required surface or state is missing
- Core user flow is broken or impossible to follow
- Layout is unreadable or non-functional

**P1 (delivery blocker):**
- Misleading semantics (wrong component type used, e.g., checkbox for single-select)
- Required copy is missing or materially wrong
- Design system rule violated (library component redrawn with primitives)
- Structural maintainability failure (flat primitives only, no Auto Layout)

**P2 (non-blocking):**
- Spacing inconsistency
- Copy polish
- Layer naming
- Minor visual hierarchy issue

## cause_type Attribution

Every P0 and P1 must have exactly one cause_type:

| cause_type | When to use |
|---|---|
| `requirement_misread` | The PRD was misunderstood or a requirement was missed |
| `flow_gap` | A required flow, screen, or state is absent |
| `surface_under_specified` | The delivery spec did not specify this clearly enough |
| `design_system_misuse` | Wrong component, token, or DS rule applied |
| `figma_execution_quality` | Spec was correct but Figma implementation is wrong |
| `content_or_copy_issue` | Copy, labels, or information structure is wrong |
| `baseline_preservation` | Existing UI behavior not preserved (when baseline exists) |

## Output Format

Write `scenario-quality-check.md`:

```markdown
# QA Review — <story-name>

## Summary
- P0: <count>
- P1: <count>
- P2: <count>
- Status: PASS | BLOCKED

## Issues

### [P0/P1/P2] <Issue title>
- Surface: <surface name>
- State: <state name> — **also check sibling states:** <list other states of this surface>
- Evidence: <screenshot ref or node ID>
- Description: <what is wrong>
- cause_type: <from list above>
- Fix: <what needs to change and in which stage>
- Owning stage: <delivery_spec | figma_generation>

## Checked Frames
<list of frame IDs reviewed>

## Notes
<Any observations that are not issues but worth noting>
```

## Update task-state.json
- Set `stories[].quality_gate.p0`, `.p1`, `.p2` counts.
- If p0 > 0 or p1 > 0: set `stories[].stages.qa_review` to `not_started`. Set the owning stage for the highest-severity issue to `not_started`.
- If p0 = 0 and p1 = 0: set `stories[].stages.qa_review` to `passing`.
- Append timeline entry.

## Write Execution Log
Write `logs/05-qa-review-<story-id>.md` using the standard log format.
