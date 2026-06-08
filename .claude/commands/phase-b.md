Handle PM feedback or a PRD change using Phase B triage.

Arguments: $ARGUMENTS (the PM feedback or change description)

## The feedback to triage:
$ARGUMENTS

## Steps

1. Read `SOUL.md`.

2. Read the active task's `task-state.json`:
   - Confirm Phase A has completed (at least one story with `design_map = "passing"`).
   - Note available stories and their `figma_section_id`.

3. Run Phase B triage following `AGENTS.md §Phase B`:

   **B0 — Story Attribution**
   Which story does this feedback belong to?

   **B1 — Scope Check**
   Is this within the current PRD?
   - No → stop: "This is new scope. Please update the PRD first."

   **B2 — Triage**
   | Size | Path |
   |---|---|
   | SMALL (copy, color, spacing) | HOT FIX — do directly |
   | MEDIUM (missing state, layout) | SURFACE — invoke @agent-delivery-spec-writer then @agent-figma-generator |
   | LARGE (new page, new flow) | ESCALATE → @agent-delivery-spec-writer from scratch |

4. For HOT FIX: execute directly (validate Design Map node IDs first).
   For SURFACE/ESCALATE: invoke the relevant subagents in order.

5. Append to `current/changelog.md`. If semantics changed → also update `ui-delivery-spec.md`.
