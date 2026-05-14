# Verification

## Harness Checks

Run after workflow/template/agent changes:

```bash
scripts/verify-harness.sh
```

Expected:
- agent configs have required shape
- template JSON parses
- baseline/research/Figma/revision schema is present
- no stale workflow terms
- no `.DS_Store`

## Stage Gates

| Stage | Required evidence |
| --- | --- |
| PRD Intake | generated task id, PRD copied/reference stored, `intent-requirement` active |
| Baseline Reference | existing UI source summarized when required |
| Research Reference | domain/reference research summarized when required |
| Intent / Requirement | quality, scope, target user, core task, criteria, constraints, open questions |
| Flow Spec | main path, branches, empty/error/permission states, completion |
| Surface Generation Spec | surfaces, states, content blocks, actions, interaction rules |
| Final UI | Figma MCP, target URL, Section/title/flow-title evidence, frame ids, assumptions, QA targets |
| Scenario / Quality Check | screenshot-backed review, canvas assembly review, severity classification, P0/P1 count |
| Revision Request | PM feedback, atomic changes, impact level, routed stage, QA scope |

## Consistency Checks

For each active stage:
- PRD path comes from `task-state.json`.
- Direct upstream artifact is the execution contract.
- `baseline-reference.md` is used as preservation context when `baseline.status` is `summarized`.
- `research-reference.md` is used as domain/pattern context when `research.status` is `summarized`.
- Earlier artifacts are context, not rewrite targets.
- Conflicts are recorded in Context Delta.
- The agent writes only its owned artifact plus `task-state.json`.

For revisions:
- `revision-request.md` captures PM feedback.
- Each change has impact level and routed stage.
- Only the earliest impacted owner becomes active.
- Previous Figma frames are preserved by default.
- QA covers changed frames and affected scenarios.

## Delivery Gate

First-pass delivery requires:
- task id matches project folder
- all non-revision-only stages passing
- baseline summarized when required
- research summarized when required
- Figma target, Section evidence, and created frames recorded
- `scenario-quality-check.md` says `P0/P1 remaining: 0`
- unresolved P2/open questions recorded

Revision delivery additionally requires:
- `revision.current_revision`
- `revision.request_artifact`
- `revision.status` is `ready_for_review` or `approved`
- revision frame ids when UI changed
- revision QA with `P0/P1 remaining: 0`
