# Workflow Contract

This contract defines the durable rules for turning a PRD into reviewable Vine UI drafts and iterating on PM feedback.

## Core Model

```text
PRD
-> Context Intake:
     optional baseline-reference
     optional research-reference
-> intent-requirement
-> flow-spec
-> surface-generation-spec
-> final-ui
-> scenario-quality-check
-> reviewable delivery
-> optional revision loop
```

Authority order:
1. PRD source of truth
2. direct upstream artifact / revision request
3. context intake artifacts as supporting context
4. earlier passing artifacts as context
5. Scenario / Quality Check for delivery or loopback

Project-specific content lives only under:

```text
projects/<task-id>/progress.md
projects/<task-id>/session-handoff.md
projects/<task-id>/current/
```

Reusable workflow content lives in `docs/`, `harness/templates/`, `scripts/`, `.codex/agents/`, and `.codex/skills/`.

## State Rules

Each task has `projects/<task-id>/current/task-state.json`.

Allowed stage states:
- `not_started`
- `active`
- `blocked`
- `passing`

Rules:
- Only one stage may be `active`.
- A stage is `passing` only after its artifact and completion evidence exist.
- Downstream stages wait for dependencies to pass.
- `revision_only` stages are ignored for first-pass delivery when `revision.status` is `none`.
- Missing user input uses `blocked_input_request`.
- P0/P1 issues route back to the owning stage.

## Stages

| Stage | Owner | Writes | Direct upstream |
| --- | --- | --- | --- |
| `intent-requirement` | `intent-requirement-analyst` | `intent-requirement.md`, `task-state.json` | PRD |
| `flow-spec` | `userflow-designer` | `flow-spec.md`, `task-state.json` | `intent-requirement.md` |
| `surface-generation-spec` | `ui-architecturer` | `surface-generation-spec.md`, `task-state.json` | `flow-spec.md` |
| `final-ui` | `figma-ui-designer` | Figma frames, `final-ui-reference.md`, `task-state.json` | `surface-generation-spec.md` or `revision-request.md` |
| `scenario-quality-check` | `user-advocate` | `scenario-quality-check.md`, `task-state.json` | `final-ui-reference.md` |
| `revision-request` | `revision-manager` | `revision-request.md`, `task-state.json` | PM feedback |

Stage-specific output shape and detailed checks live in the matching skill. Load only the skill for the active stage.

## Figma Canvas Assembly

Final UI output must be organized as a reviewable Figma design package, not loose frames.

Surface Generation Spec provides the user-flow grouping and intended frame order. Final UI creates or uses a containing Section, applies the standard Section/title/flow-label styling defined in `final-ui-generation`, arranges frames by interaction flow, and records Section evidence in `task-state.json` and `final-ui-reference.md`.

Scenario / Quality Check verifies canvas assembly before delivery.

## Baseline Design Intake

Context Intake has independent optional checks. Baseline and research are not mutually exclusive.

Use `baseline-reference.md` when the task is based on an existing UI.

Triggers include:
- user provides a Figma link or UI screenshot
- PRD says current page, existing design, optimize, adjust, add entry, revamp, preserve, or do not change current design

If a baseline is required but missing, block the active stage with `blocked_input_request` and ask for a Figma link or screenshot.

`task-state.json.baseline` records:
- `mode`: `none`, `figma`, or `image`
- `required`
- `status`: `none`, `missing`, `available`, or `summarized`
- source URL/file and Figma file/node ids
- `artifact`: `projects/<task-id>/current/baseline-reference.md`

Downstream stages read the compact baseline artifact only when present. Avoid repeatedly loading full Figma metadata or raw screenshots.

## Research Intake

Use `research-reference.md` when the task needs domain background, best practices, reference products, or current external knowledge.

Triggers include:
- user asks to search, research, compare, find best practices, or find references
- domain is unfamiliar, emerging, or fast-moving
- task benefits from product-pattern examples

`task-state.json.research` records:
- `required`
- `status`: `none`, `needed`, `in_progress`, or `summarized`
- `topics`
- `artifact`: `projects/<task-id>/current/research-reference.md`
- `sources`

Research supplements the PRD. It cannot override the PRD, and downstream stages read only the compact research artifact unless fresh verification is needed.

## Blocked Input

Use `blocked_input_request` only for missing user-provided data, such as `figma.target_url`.

Required fields:
- `stage`
- `reason`
- `required_fields`
- `optional_fields`
- `prompt`
- `status`: `none`, `waiting_for_user`, or `resolved`

When the user provides the input, validate it, write it into `task-state.json`, clear `blocked_input_request`, and restore the blocked stage to `active` unless another blocker remains.

## Revision Loop

A revision is PM feedback attached to an existing reviewable delivery. It is not a new PRD task unless the PM explicitly asks to start over.

Revision states:
- `none`
- `active`
- `ready_for_review`
- `approved`

`revision-manager` creates `revision-request.md`, classifies each atomic change, and routes to the earliest impacted stage:

```text
requirement-change -> intent-requirement
flow-change        -> flow-spec
surface-change     -> surface-generation-spec
final-ui-only      -> final-ui
```

Routed stages treat `revision-request.md` as the direct upstream contract and preserve unchanged artifacts/frames. Final UI creates versioned replacement frames by default and records `revision.created_frame_ids` / `revision.superseded_frame_ids`.

## Delivery Gates

First-pass delivery requires:
- all non-revision-only stages `passing`
- baseline summarized when `baseline.required` is true
- research summarized when `research.required` is true
- Figma target, Section evidence, and generated frame ids recorded
- Scenario / Quality Check passing
- `P0/P1 remaining: 0`
- P2 risks and open questions recorded

Revision reviewability requires:
- current `revision-request.md`
- routed implementation evidence
- changed frame ids when Final UI changed
- Scenario / Quality Check over affected scenarios plus primary-flow regression
- `P0/P1 remaining: 0`
