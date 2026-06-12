---
name: qa-review
description: Validate Figma output against the delivery spec and PRD. Classify all issues with severity and cause_type. Gate delivery — only p0 must be zero to pass; p1/p2 are recorded but non-blocking.
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
4. **Large tool-result guard**: If a Figma MCP call returns a cached file that exceeds 25K tokens when read, use `offset` + `limit` parameters on the Read tool to extract only the section you need (e.g., search for a specific `node_id` substring first with Bash grep, then read around that offset).

## Figma MCP Precision Rules

### `whoami`
- Use only for connectivity check. One call per session, at Preflight.

### `get_metadata`
- Always pass `node_id` (the Frame ID from `final-ui-reference.md`). Never call on the file URL.
- One call per frame row — no more.

### `get_design_context`
- Always pass `node_id`. Never call without it.
- Use only when `get_metadata` reveals an anomaly that requires style/bounding-box details to diagnose (e.g., suspecting a fill color mismatch). Do not use as a substitute for `get_metadata` in the structural scan.
- Maximum 1 call per flagged frame — not for every frame.

### `get_screenshot`
- Hard cap: **maximum 15 screenshots per QA session** (across all frames in the story).
- Follow the Phase 2 targeting rules below. If Phase 1 finds no anomalies, stop at 1 screenshot per surface regardless of state count.

---

## Inspection Protocol — Metadata First, Screenshot on Demand

**Do NOT screenshot all frames upfront.** Screenshots are expensive. Use the following two-phase approach:

### Phase 1 — Structural scan (metadata only)
For each frame in `final-ui-reference.md`, call `get_metadata` with the specific frame's `node_id` to retrieve that frame's node tree.

**Where to get `node_id`**: The "Frame ID" column in `final-ui-reference.md` is the `node_id`. Use that value directly as the `node_id` parameter — one `get_metadata` call per row.

**Critical: Always pass `node_id`.** Never call `get_metadata` on the file URL alone — it returns the entire file tree and will exceed the 25K-token read limit on any non-trivial Figma file.
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

**P0 (hard blocker — triggers immediate rework):**
- Required surface or state is missing
- Core user flow is broken or impossible to follow
- Layout is unreadable or non-functional

**P1 (recorded, non-blocking for Phase A):**
- Misleading semantics (wrong component type used, e.g., checkbox for single-select)
- Required copy is missing or materially wrong
- Design system rule violated (library component redrawn with primitives)
- Structural maintainability failure (flat primitives only, no Auto Layout)

**P2 (recorded, non-blocking):**
- Spacing inconsistency
- Copy polish
- Layer naming
- Minor visual hierarchy issue

## cause_type Attribution

Every P0 must have exactly one cause_type. P1 and P2 should also include cause_type where known:

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
- If p0 > 0: set `stories[].stages.qa_review` to `not_started`. Set `figma_generation` to `not_started` for rework. P1/P2 do **not** trigger rework.
- If p0 = 0: set `stories[].stages.qa_review` to `passing` (regardless of p1/p2 count).
- Append timeline entry.

## Write Execution Log
Write `logs/05-qa-review-<story-id>.md` using the standard log format.
