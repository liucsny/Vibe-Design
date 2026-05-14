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
| Design System Reference | active adapter summarized, required library subscription checked, public component families selected, importable library/component keys recorded, internal components excluded, fallback rules recorded |
| Intent / Requirement | quality, scope, target user, core task, criteria, constraints, open questions |
| Flow Spec | main path, branches, empty/error/permission states, completion |
| Surface Generation Spec | surfaces, states, content blocks, actions, interaction rules, structured Figma requirements |
| Final UI | Figma MCP, target URL, required Figma library subscription evidence, imported public component instance evidence, Section/title/flow-title evidence, frame ids, Auto Layout evidence, text sizing/truncation evidence, assumptions, QA targets |
| Scenario / Quality Check | screenshot-backed review, canvas assembly review, imported component instance review, node-tree maintainability review, text overflow/truncation review, severity classification, P0/P1 count |
| Revision Request | PM feedback, atomic changes, impact level, routed stage, QA scope |

## Consistency Checks

For each active stage:
- PRD path comes from `task-state.json`.
- Direct upstream artifact is the execution contract.
- `baseline-reference.md` is used as preservation context when `baseline.status` is `summarized`.
- `research-reference.md` is used as domain/pattern context when `research.status` is `summarized`.
- `design-system-reference.md` is used as the active component/style contract when `design_system.status` is `summarized`.
- `design-system-reference.md` must include importable `libraryKey` / `componentKey` evidence for every required public component family before Final UI writes frames.
- Earlier artifacts are context, not rewrite targets.
- Conflicts are recorded in Context Delta.
- The agent writes only its owned artifact plus `task-state.json`.
- Final UI must follow the structured Figma requirements from `surface-generation-spec.md`; if the requirements are missing or weak, route back to Surface Generation Spec before generating final frames.
- Final UI must not start when `design_system.required` is true and `design_system.status` is not `summarized`.
- Final UI must not start when the target Figma file is not subscribed to the required design system library or required public components lack importable keys.
- Final UI must instantiate required public Figma components directly; redrawing them with primitives or local fallbacks is a P1 failure.

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
- target Figma file is subscribed to the required design system library
- required public component families are instantiated from Figma component keys
- Figma target, Section evidence, and created frames recorded
- `final-ui-reference.md` records design system, library subscription, imported component instances, structure, text sizing, truncation, and fallback evidence required by `structured-figma-gates.md`
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
