# Vibe Design Agent Guide

Read `SOUL.md` first. It defines who you are, your behavior principles, and your safety red lines.

## Quick Start — New Task from PRD

When a user provides a PRD (pasted text, local file, or Feishu/Lark link), initialize the task and start Phase A:

```bash
# PRD as Feishu/Lark link
scripts/init-task-from-prd.sh --lark-url "<url>" --title "<short-english-title>"

# PRD as local file
scripts/init-task-from-prd.sh --file <path> --title "<short-english-title>"

# PRD pasted in chat
scripts/init-task-from-prd.sh --text "<prd-text>" --title "<short-english-title>"
```

The script creates `projects/<task-id>/` with the standard directory structure and writes `current/prd.md` and `current/task-state.json`.

---

## Phase A: Foundation Build

**Goal:** Turn a PRD into a complete, high-quality initial design. Run once per PRD (or per significant PRD change).

### Shared Stages (run once, before any story work)

```
① prd-analyst        → current/prd-analysis.json
② context-scout      → current/design-brief.md
```

### Per-Story Loop (run for each story in dependency order)

```
③ delivery-spec-writer  → current/stories/<story-id>/ui-delivery-spec.md
④ figma-generator       → Figma frames + current/stories/<story-id>/final-ui-reference.md
⑤ qa-reviewer           → current/stories/<story-id>/scenario-quality-check.md
⑥ design-map-builder    → current/stories/<story-id>/design-map.json
```

After all stories pass: run Cross-Story Consistency Check (qa-reviewer reads all final-ui-reference.md files), then create `milestones/v0/` snapshot.

### Stage Status Rules

- Statuses: `not_started | active | blocked | passing`
- Only one stage may be `active` at a time within a story.
- A stage is `passing` only after its artifact exists and completion evidence is written.
- If a stage is blocked on missing user input, set status to `blocked`, populate `blocked_input_request` in `task-state.json`, and show a concise prompt in chat.
- `qa_review` may only be set to `passing` when `quality_gate.p0 = 0` and `quality_gate.p1 = 0`.

### Multi-Story PRDs

When `scope_type = "multi_story"`:
- Run shared stages once.
- Run per-story loop for each story in `task-state.json.stories`, respecting `depends_on` order.
- Default: sequential. Only parallelize if PM explicitly confirms zero UI-pattern dependency between stories.
- After all stories complete: run Cross-Story Consistency Check.

---

## Phase B: Adjustment Loop

**Goal:** Respond to PM feedback or PRD changes quickly. Use the Design Map to skip the pipeline when possible.

Trigger: PM gives feedback, or user says "adjust / change / fix / [describes a change]".

### Step B0 — Story Attribution

Which story does this change belong to?
- Single story → continue.
- Spans multiple stories → split into separate changes, route each independently.
- Affects shared layer (global navigation, design language) → **Escalate**, affects all stories.

### Step B1 — Scope Check

Is this change within the current PRD?
- Yes → continue to B2.
- No → stop. Tell the user: *"This looks like new scope. Please update the PRD first, then I can run Phase A for the affected story."*

### Step B2 — Triage

| Change Type | Examples | Path | Target |
|---|---|---|---|
| SMALL | copy, color, spacing, component variant | HOT FIX | fast |
| MEDIUM | missing state, layout change, error handling | SURFACE | moderate |
| LARGE | new page, new flow, navigation change | ESCALATE → Phase A | as needed |
| New Story | PM adds a new independent module | mini Phase A | from delivery-spec-writer |

**HOT FIX path:**
1. Validate Design Map node IDs before touching Figma (check `stale` flags).
2. Apply change via Figma MCP directly.
3. Run lightweight QA (changed nodes + DS compliance only).
4. Update `design-map.json` if new nodes created.
5. Append to `current/changelog.md`.
6. If change affects semantics or states → also update `ui-delivery-spec.md`.

**SURFACE path:**
1. Locate affected surfaces in Design Map.
2. Re-run delivery-spec-writer for affected surfaces only.
3. Re-run figma-generator for affected surfaces only.
4. Run targeted QA + light regression on adjacent surfaces.
5. Rebuild affected Design Map entries.
6. Append to `current/changelog.md`.

**ESCALATE path:**
1. Mark affected story stages as `not_started` in `task-state.json`.
2. Re-enter Phase A from the appropriate stage (delivery-spec-writer or earlier).
3. Run full QA after regeneration.
4. Rebuild full Design Map for affected story.

### Phase B Completion

After PM Review approval: run Gate QA (full), create `milestones/vN/` snapshot, append to `learning-report.md`.

---

## Context Loading Policy

- Read `SOUL.md` and `task-state.json` at the start of every session.
- Load only the skill file for the active stage. Do not preload other skills.
- Load `design-brief.md` when running delivery-spec-writer, figma-generator, or qa-reviewer.
- Load `ui-delivery-spec.md` only for the story being actively worked on.
- Do not load Figma raw node dumps into context. Use `final-ui-reference.md` summaries.
- Load `design-map.json` only during Phase B Hot Fix or Surface paths.

## Design Systems

Design system constraints live under `.codex/design-systems/` when configured. If the directory is empty or missing, note the gap in `design-brief.md` and proceed with Vine product patterns and PRD requirements only. Do not block Phase A on missing design system configuration.

## Session Exit

Before ending any session where a task is active:
1. Update `task-state.json` — set the correct stage status and `timeline` entry.
2. Write the execution log for the last completed stage to `projects/<task-id>/logs/`.
3. If a stage is mid-execution, set status to `active` and note the next action in `blocked_input_request` or in the log.
