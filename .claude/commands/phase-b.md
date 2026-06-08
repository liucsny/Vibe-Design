Handle PM feedback or a PRD change using Phase B triage.

Arguments: $ARGUMENTS (the PM feedback or change description — can be left empty if already in context)

## The feedback to triage:
$ARGUMENTS

## Steps

1. Read `SOUL.md`.

2. Read `projects/<task-id>/current/task-state.json`:
   - Confirm Phase A has completed (at least one story with `design_map = "passing"`).
   - Note available stories and their `figma_section_id`.

3. Run Phase B triage following `AGENTS.md` §Phase B:

   **B0 — Story Attribution**
   Which story does this feedback belong to?
   - Single story → continue.
   - Multiple stories → split, handle each independently.
   - Shared layer (DS, global nav) → Escalate affects all stories.

   **B1 — Scope Check**
   Is this within the current PRD?
   - Yes → continue.
   - No → stop. Tell the user: "This is new scope. Please update the PRD first."

   **B2 — Triage**
   | Size | Examples | Path |
   |---|---|---|
   | SMALL | copy, color, spacing, component variant | HOT FIX |
   | MEDIUM | missing state, layout change | SURFACE |
   | LARGE | new page, new flow | ESCALATE → Phase A |

4. Execute the chosen path per `docs/workflow-contract.md` §10.

5. Append to `current/changelog.md`. If change affects semantics → also update `ui-delivery-spec.md`.
