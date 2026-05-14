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
| Design System Reference | active adapter summarized, public component families selected, internal components excluded, fallback rules recorded |
| Intent / Requirement | quality, scope, target user, core task, criteria, constraints, open questions |
| Flow Spec | main path, branches, empty/error/permission states, completion |
| Surface Generation Spec | surfaces, states, content blocks, actions, interaction rules, structured Figma requirements |
| Final UI | Figma MCP, target URL, Section/title/flow-title evidence, frame ids, component/Auto Layout evidence, text sizing/truncation evidence, assumptions, QA targets |
| Scenario / Quality Check | screenshot-backed review, canvas assembly review, node-tree maintainability review, text overflow/truncation review, severity classification, P0/P1 count |
| Revision Request | PM feedback, atomic changes, impact level, routed stage, QA scope |

## Consistency Checks

For each active stage:
- PRD path comes from `task-state.json`.
- Direct upstream artifact is the execution contract.
- `baseline-reference.md` is used as preservation context when `baseline.status` is `summarized`.
- `research-reference.md` is used as domain/pattern context when `research.status` is `summarized`.
- `design-system-reference.md` is used as the active component/style contract when `design_system.status` is `summarized`.
- Earlier artifacts are context, not rewrite targets.
- Conflicts are recorded in Context Delta.
- The agent writes only its owned artifact plus `task-state.json`.
- Final UI must follow the structured Figma requirements from `surface-generation-spec.md`; if the requirements are missing or weak, route back to Surface Generation Spec before generating final frames.
- Final UI must not start when `design_system.required` is true and `design_system.status` is not `summarized`.

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
- design system summarized when required
- Figma target, Section evidence, and created frames recorded
- `final-ui-reference.md` records design system, structure, text sizing, truncation, and fallback evidence required by `structured-figma-gates.md`
- `scenario-quality-check.md` includes screenshot-backed review plus node-tree maintainability review
- `scenario-quality-check.md` says `P0/P1 remaining: 0`
- unresolved P2/open questions recorded

Revision delivery additionally requires:
- `revision.current_revision`
- `revision.request_artifact`
- `revision.status` is `ready_for_review` or `approved`
- revision frame ids when UI changed
- structured Figma evidence for changed frames when UI changed
- design system evidence for changed frames when UI changed
- revision QA with `P0/P1 remaining: 0`
