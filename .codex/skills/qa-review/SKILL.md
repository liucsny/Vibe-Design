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
2. Capture screenshots of all frames listed in `final-ui-reference.md` via Figma MCP.
3. Do not proceed from screenshots alone. Also inspect node tree for structure and component evidence.

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
- State: <state name>
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
