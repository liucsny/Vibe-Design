# Vine Vibe Design

Vine Vibe Design turns a PM PRD into reviewable Vine UI drafts in Figma, then supports PM feedback as repeatable revisions.

## Workflow

```text
PRD
  -> Context Intake
       optional Baseline Reference
       optional Research Reference
       required Design System Reference
  -> Intent / Requirement
  -> Flow Spec
  -> Surface Generation Spec
  -> Final UI in Figma
  -> Scenario / Quality Check
  -> Reviewable Delivery
  -> optional PM Feedback / Revision Request
```

Each stage reads the PRD plus its direct upstream contract, and writes only its owned artifact plus `task-state.json`.

## Context Loading

Use progressive disclosure by default:
- start from `task-state.json`, PRD, and the active stage's direct upstream artifact
- read summarized context artifacts only when present: `baseline-reference.md`, `research-reference.md`, `design-system-reference.md`
- load one active stage skill, plus only the small reference files it explicitly asks for
- avoid raw Figma metadata, raw screenshots, full web search logs, and full design-system files unless the current stage needs them
- use `docs/verification.md` for delivery or harness checks, not as default generation context

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
    ├── design-system-reference.md
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

Delivery is reviewable only when required stages are passing, required context intake is summarized, generated Figma evidence exists, and Scenario / Quality Check records `P0/P1 remaining: 0`.

Use `docs/verification.md` for the complete gate checklist. Use `.codex/skills/final-ui-generation/references/structured-figma-gates.md` only during Final UI or QA.

## Verification

After workflow changes:

```bash
scripts/verify-harness.sh
```
