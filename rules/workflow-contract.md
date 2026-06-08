# Workflow Contract — Vibe Design v4.1-MVP

This document is the authoritative rule set for all agents. Read the relevant section for your active stage. Do not read this file in full unless debugging a contract violation.

---

## 1. Core Model

Vibe Design operates in two phases:

**Phase A — Foundation Build**: PRD → prd-analysis → design-brief → (per story) delivery-spec → figma-generation → qa-review → design-map → baseline snapshot.

**Phase B — Adjustment Loop**: PM feedback → triage → Hot Fix / Surface / Escalate → changelog → (at milestone) snapshot.

The phases are separated. Phase B only starts after Phase A has produced at least one passing story with a Design Map.

---

## 2. Agent Ownership

Each agent owns exactly one artifact. No agent modifies another agent's artifact.

| Agent | Owns | Reads |
|---|---|---|
| prd-analyst | `prd-analysis.json`, `task-state.json` (shared fields) | `prd.md` |
| context-scout | `design-brief.md`, `task-state.json` (shared fields) | `prd.md`, `prd-analysis.json`, `.codex/design-systems/` (if exists) |
| delivery-spec-writer | `stories/<id>/ui-delivery-spec.md`, `task-state.json` (story stage) | `design-brief.md`, PRD story sections |
| figma-generator | `stories/<id>/final-ui-reference.md`, `task-state.json` (story stage) | `ui-delivery-spec.md`, `design-brief.md` |
| qa-reviewer | `stories/<id>/scenario-quality-check.md`, `task-state.json` (quality_gate) | `ui-delivery-spec.md`, PRD, Figma screenshots, `final-ui-reference.md` |
| design-map-builder | `stories/<id>/design-map.json`, `task-state.json` (story stage) | `final-ui-reference.md`, Figma node scan |

---

## 3. State Machine

Valid transitions per stage:

```
not_started → active → passing
not_started → active → blocked → active → passing
```

Rules:
- Only one stage may be `active` per story at a time.
- A stage cannot move to `passing` without its artifact existing and completion evidence recorded.
- `qa_review` requires `p0 = 0` AND `p1 = 0` to reach `passing`.
- A blocked stage must populate `blocked_input_request` in `task-state.json`.

---

## 4. PRD Analysis Rules

`prd-analyst` must:
- Assign a quality score (1–10). Score < 6 → list specific ambiguities, ask for clarification before continuing.
- Detect `scope_type`: single_story if one coherent flow; multi_story if PRD contains clearly separated feature modules with distinct UI surfaces.
- For multi_story: identify story boundaries, name each story, detect dependencies.
- Domain classification: `feature-add | revamp | data-heavy | workflow | ai-product`.
- Output `prd-analysis.json`. Do not produce UI decisions.

---

## 5. Design Brief Rules

`context-scout` must:
- Produce a single `design-brief.md` shared by all stories.
- DS Scout thread: check `.codex/design-systems/` for configured design system. If found, verify component availability and token coverage for PRD requirements. If empty/missing, note the gap and continue.
- UX Scout thread: identify relevant product patterns, interaction conventions, a11y requirements for the domain and PRD type.
- The brief must be structured and queryable — use clear headers so downstream agents can load specific sections without reading the full file.
- Do not include raw research dumps. Synthesize to actionable constraints.

---

## 6. UI Delivery Spec Rules

`delivery-spec-writer` must:
- Produce one `ui-delivery-spec.md` per story.
- Cover every surface in the story. For each surface: name, entry point, all required states (default, loading, empty, error, success, and any PRD-specific states), component plan, layout structure.
- Map components to library entries when a design system is configured.
- Flag surfaces where the PRD is ambiguous rather than guessing silently.
- The spec is the sole input contract for `figma-generator`. If the spec is incomplete, figma-generator must block, not guess.

---

## 7. Figma Generation Rules

`figma-generator` must:
- Verify Figma MCP is available before starting. If not, set stage to `blocked`.
- Verify `figma.target_url` is set in `task-state.json`. If not, request it.
- Generate all surfaces and states listed in `ui-delivery-spec.md`. Do not skip states.
- Use Auto Layout for all primary containers.
- Organize all frames in a named Figma Section with `300px` padding.
- When a design system adapter is configured: import components from the library, do not redraw with primitives.
- Record all created frame IDs in `final-ui-reference.md` with surface name, state, and frame ID.

---

## 8. QA Review Rules

`qa-reviewer` must:
- Check screenshots AND metadata. Do not pass from metadata alone.
- Coverage checks: PRD requirement coverage, all states generated, copy quality, baseline drift (if baseline exists).
- Structural checks: Auto Layout on primary containers, component reuse for repeated patterns, no flat primitive-only construction.
- Classify each issue: P0 (blocking — missing required surface/flow, broken layout), P1 (blocking — misleading semantics, incomplete required copy, DS misuse), P2 (non-blocking — polish).
- Every P0 and P1 must have a `cause_type` from this list:
  - `requirement_misread` — PRD was misunderstood
  - `flow_gap` — required flow or state is missing
  - `surface_under_specified` — spec did not define this clearly enough
  - `design_system_misuse` — component or token used incorrectly
  - `figma_execution_quality` — correct spec, wrong Figma implementation
  - `content_or_copy_issue` — copy, labels, or information structure problem
  - `baseline_preservation` — existing UI behavior not preserved
  - `pm_feedback_new_scope` — feedback asks for something not in the PRD (Phase B only)
- P0 or P1 present → set owning stage back to `not_started`, set qa_review to `not_started`.
- All p0 = 0 and p1 = 0 → set `qa_review` to `passing`.

---

## 9. Design Map Rules

`design-map-builder` must:
- Scan all Figma frames created for the story.
- For each surface: record `frame_id`, `prd_section`, list of states, and key element → `node_id` mappings.
- For each entry: set `stale: false` and `last_verified: <timestamp>`.
- Record `meta.last_validated` and `meta.figma_file_version` in the map root.
- Validate all node IDs exist via Figma API before writing.

**Phase B Map usage:**
- Before any Hot Fix: validate all target node IDs. Any `stale: true` entry must be rebuilt before use.
- After any operation that creates new Figma nodes: update the map entries for affected surfaces.
- If a Surface or Escalate path rebuilds a frame: mark all map entries for that surface as `stale: true`, then rebuild after QA passes.

---

## 10. Phase B Rules

**Changelog format** — append one row per change to `current/changelog.md`:

```
| adj-id | timestamp | story_id | path | description | cause_type |
```

**Spec sync rule:**
- HOT FIX changes to visual properties only (color, spacing, copy) → changelog only.
- HOT FIX changes to component choice, state presence, or interaction semantics → also update `ui-delivery-spec.md`.
- SURFACE and ESCALATE paths always update `ui-delivery-spec.md`.

**Scope discipline:**
- If PM feedback introduces a feature or surface not in the PRD → stop. Ask PM to update the PRD first.

---

## 11. Execution Logs

Every stage writes a log to `projects/<task-id>/logs/<NN>-<stage-name>.md` on completion.

Minimum content:
```
# <Stage Name> Log
Timestamp: <ISO timestamp>
Status: passing | blocked | failed

## Inputs Read
- <file path>: <one-line description of what was used>

## Key Decisions
- <decision and why>

## Output
- <artifact path>: <brief description>

## Issues / Blockers
- <if any>
```

---

## 12. Delivery Gate

A story is ready for PM review when:
- `qa_review` status = `passing`
- `quality_gate.p0 = 0` and `quality_gate.p1 = 0`
- `design_map` status = `passing`
- All Figma frames for the story are in the named Section

A milestone snapshot (`milestones/vN/`) is created when PM approves a review. Copy the full `current/` directory to `milestones/vN/`. Snapshots are immutable.
