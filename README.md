# Vine Vibe Design

Vine Vibe Design turns a PM PRD into reviewable Vine UI drafts in Figma, then supports PM feedback as repeatable revisions.

## Workflow

```text
PRD
  -> Context Intake
       optional Baseline Reference
       optional Research Reference
  -> Intent / Requirement
  -> Flow Spec
  -> Surface Generation Spec
  -> Final UI in Figma
  -> Scenario / Quality Check
  -> Reviewable Delivery
  -> optional PM Feedback / Revision Request
```

Each stage reads the PRD plus its direct upstream contract, and writes only its owned artifact plus `task-state.json`.

## Repository Layout

```text
docs/                 reusable workflow contract and verification rules
harness/templates/    task-state, progress, handoff templates
scripts/              task initialization and verification scripts
.codex/agents/        stage agents
.codex/skills/        stage instructions
projects/<task-id>/   one self-contained PRD/design task
```

Project files:

```text
projects/<task-id>/
├── progress.md
├── session-handoff.md
└── current/
    ├── task-state.json
    ├── prd.md
    ├── baseline-reference.md
    ├── research-reference.md
    ├── intent-requirement.md
    ├── flow-spec.md
    ├── surface-generation-spec.md
    ├── final-ui-reference.md
    ├── scenario-quality-check.md
    └── revision-request.md
```

## Start A Task

For pasted PRDs:

```bash
scripts/init-task-from-prd.sh --text "<prd text>" --title "<short-title>"
```

For PRD files:

```bash
scripts/init-task-from-prd.sh --file <prd-file> --title "<short-title>"
```

Use the generated `task_id`; do not rename it.

See `docs/workflow-contract.md` for artifact ownership, Context Intake, revision routing, and delivery gates.

## Revision Loop

After Scenario / Quality Check passes, PM feedback enters through `revision-manager`.

```text
PM Feedback
  -> revision-request.md
  -> routed stage:
       final-ui-only      -> final-ui
       surface-change     -> surface-generation-spec
       flow-change        -> flow-spec
       requirement-change -> intent-requirement
  -> scenario-quality-check
  -> New Reviewable Delivery
```

Revisions preserve prior Figma frames by default and create versioned replacements.

## Delivery Gate

First-pass delivery requires:
- all non-revision-only stages passing
- baseline summarized when required
- research summarized when required
- Figma target, Section evidence, and created frame ids
- Scenario / Quality Check with `P0/P1 remaining: 0`
- P2 risks/open questions recorded

Revision reviewability requires:
- current `revision-request.md`
- routed-stage evidence
- changed frame ids when UI changed
- Scenario / Quality Check with `P0/P1 remaining: 0`

## Verification

After workflow changes:

```bash
scripts/verify-harness.sh
```
