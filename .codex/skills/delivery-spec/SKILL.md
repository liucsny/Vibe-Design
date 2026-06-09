---
name: delivery-spec
description: Translate PRD story requirements into a precise UI delivery spec. Defines every surface, state, component, and layout structure. The sole input contract for figma-generator.
---

# UI Delivery Spec

## Inputs
- `current/design-brief.md`
- `current/prd.md` (relevant story sections from prd-analysis.json)
- `current/prd-analysis.json`
- `current/task-state.json` (to confirm active story and stage)

## Output
- `current/stories/<story-id>/ui-delivery-spec.md`
- Updated `current/task-state.json` (story delivery_spec → passing)
- `logs/03-delivery-spec-<story-id>.md`

## Preflight
1. Confirm `shared.context_scout = passing`.
2. Confirm active story id from task-state.json.
3. Confirm story's `delivery_spec` stage is `active`.

## Steps

### 1. Read Inputs
- Read `design-brief.md` — especially "Design System" and "Required States" sections.
- Read the PRD sections listed for this story in prd-analysis.json.

### 2. List All Surfaces
Enumerate every distinct UI screen or panel in the story. A surface = one Figma frame.

For each surface, determine:
- Entry point (what triggers the user to arrive here)
- Completion condition (what the user does to leave or finish)
- Required states (at minimum: default, loading, empty, error; plus any story-specific states)

If a required state is not specified in the PRD but is standard for the surface type (per design-brief "Required States"), include it and note it was inferred.

### 3. Specify Each Surface

For each surface, write a section:

```markdown
## Surface: <name>

**Entry:** <how user arrives>
**Completion:** <how user leaves / task completes>

### States

#### Default
- Layout: <describe top-level structure — sidebar + content / single column / modal>
- Key elements: <list the primary interactive and informational elements>
- Components: <component name [library key if DS configured]>

#### Loading
- <what shows while data loads>

#### Empty
- <what shows when there is no data>
- Empty action: <primary CTA if any>

#### Error
- <error display pattern — inline / banner / toast>
- <error message copy pattern>

#### <PRD-specific state if any>
- ...

### Layout Constraints
- <Auto Layout direction, gap, padding>
- <Any fixed dimensions or scroll behavior>

### Navigation Outputs
List every user action on this surface that causes navigation to another surface or state, in the format:
- `[trigger]` → `[destination surface / state]` (note any data carried or UI feedback, e.g. "success toast", "row highlighted")

### Open Questions
- <Anything in this surface that the PRD does not specify clearly enough to build>
```

### 3b. Write Navigation Map

After all surfaces are specified, write a `## Navigation Map` section at the end of the spec.

This section is the **single source of truth for cross-surface flow**. It must:
- Show every surface-to-surface transition as an ASCII flow graph
- Identify the happy path (mark with `★`)
- Identify error recovery paths (mark with `⚠`)
- Call out any multi-step loops (e.g. "run → check result → modify → re-run")
- Note any intermediate UI feedback that occurs during transition (success toast, loading state, row highlight)

```markdown
## Navigation Map

### Flow Graph

★ [happy path label]
[Surface A] --<trigger>--> [Surface B / State]
[Surface A] --<trigger>--> [Surface C / Default]
[Surface C / Submitting] --success--> [Surface A / Default] (new row appears, highlighted)
[Surface C / Submitting] --error--> [Surface C / Error]

⚠ [error recovery label]
[Surface D / QC Failed] --close modal--> [Surface B / Default] (user fixes prompt)
[Surface B / Default] --re-trigger Submit--> [Surface D / QC Running]

### Multi-step Loops
- <describe any non-linear flows: loops, back-navigation, conditional branches>

### Surfaces Not Reachable from Main Flow
- <list any surfaces that are only reachable via edge cases, and from where>
```

**Rule:** The Navigation Map must account for every "Completion" listed in every surface's spec. If a surface has a completion condition that doesn't appear as an edge in the flow graph, that is a spec gap — fix it before marking delivery_spec as passing.

### 4. Validate Completeness
Before writing the file:
- Every surface from Step 2 is covered.
- Every surface has at least default + one error state.
- Every surface has a "Navigation Outputs" list — no surface may have zero outputs unless it is a terminal dead-end (e.g. a success confirmation that auto-closes).
- The Navigation Map accounts for every "Completion" condition in every surface. No completion condition is left as a dangling edge.
- No component is invented — all components are from the DS library or documented as "no library match, use local Auto Layout frame".
- No open questions are silently resolved. If ambiguous, write it in the surface's Open Questions.

### 5. Write ui-delivery-spec.md
Write the complete spec to `current/stories/<story-id>/ui-delivery-spec.md`.

### 6. Update task-state.json
- Set story's `delivery_spec` to `passing`.
- Append timeline entry.

### 7. Write Execution Log
Write `logs/03-delivery-spec-<story-id>.md` using the standard log format.
