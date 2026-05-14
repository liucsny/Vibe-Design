# Workflow Contract

This contract defines the durable rules for turning a PRD into reviewable Vine UI drafts and iterating on PM feedback.

## Core Model

```text
PRD
-> Context Intake:
     optional baseline-reference
     optional research-reference
     required design-system-reference
-> intent-requirement
-> flow-spec
-> surface-generation-spec
-> final-ui
-> scenario-quality-check
-> reviewable delivery
-> optional revision loop
```

Authority order:
1. **Core Input 1 (Anchor):** PRD source of truth
2. **Core Input 2 (Contract):** direct upstream artifact / revision request
3. **Auxiliary Input:** context intake artifacts as supporting context
4. **Auxiliary Input (Hard Constraint):** earlier passing artifacts (Do not read as default prompt material. Load ONLY to resolve specific fidelity questions or data gaps blocking execution)
5. **Auxiliary Input:** Scenario / Quality Check for delivery or loopback

Project-specific content lives only under:

```text
projects/<task-id>/progress.md
projects/<task-id>/session-handoff.md
projects/<task-id>/current/
```

Reusable workflow content lives in `docs/`, `harness/templates/`, `scripts/`, `.codex/agents/`, and `.codex/skills/`.

## Context Loading Policy

Default context should stay small:
- **Dual-Core Alignment**: Always start with the PRD (Anchor) and the active stage's direct upstream artifact (Execution Contract). These two form the core inputs. `task-state.json` provides global status.
- Read summarized context artifacts only when their status is summarized: `baseline-reference.md`, `research-reference.md`, `design-system-reference.md`.
- **Hard Constraint for Older Artifacts**: Do not read earlier passing artifacts as default prompt material. You MUST ONLY load an earlier passing artifact if the direct upstream artifact has a specific, unresolvable data gap or ambiguity that blocks execution. In such cases, use the earlier artifact strictly to bridge the missing data (fidelity check) without overriding the direct upstream contract.
- Load exactly one active stage skill unless that skill explicitly delegates to a context intake or Final UI skill.
- Load detailed references only on demand: adapter recipes selected by `design-system-reference.md`, Vine design skills only at Final UI/QA, and `structured-figma-gates.md` only at Final UI/QA.
- Do not paste raw Figma metadata dumps, full screenshot analyses, raw web results, or full design-system libraries into downstream artifacts.

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

| Stage                     | Owner                        | Writes                                                   | Direct upstream                                       |
| ------------------------- | ---------------------------- | -------------------------------------------------------- | ----------------------------------------------------- |
| `intent-requirement`      | `intent-requirement-analyst` | `intent-requirement.md`, `task-state.json`               | PRD                                                   |
| `flow-spec`               | `userflow-designer`          | `flow-spec.md`, `task-state.json`                        | `intent-requirement.md`                               |
| `surface-generation-spec` | `ui-architecturer`           | `surface-generation-spec.md`, `task-state.json`          | `flow-spec.md`                                        |
| `final-ui`                | `figma-ui-designer`          | Figma frames, `final-ui-reference.md`, `task-state.json` | `surface-generation-spec.md` or `revision-request.md` |
| `scenario-quality-check`  | `user-advocate`              | `scenario-quality-check.md`, `task-state.json`           | `final-ui-reference.md`                               |
| `revision-request`        | `revision-manager`           | `revision-request.md`, `task-state.json`                 | PM feedback                                           |

Stage-specific output shape and detailed checks live in the matching skill. Load only the skill for the active stage.

## Figma Canvas Assembly

Final UI output must be organized as a reviewable Figma design package, not loose frames.

Surface Generation Spec provides the user-flow grouping and intended frame order. Final UI creates or uses a containing Section, applies the standard Section/title/flow-label styling defined in `final-ui-generation`, arranges frames by interaction flow, and records Section evidence in `task-state.json` and `final-ui-reference.md`.

Scenario / Quality Check verifies canvas assembly before delivery.

## Structured Figma Delivery

Final UI must be maintainable Figma, not a flat visual reconstruction.

Root workflow rule:
- Final UI reads the active design system through `design-system-reference.md`; it does not hard-code a library.
- Surface Generation Spec records required component families, structure, text sizing, truncation, and fallback expectations.
- Design System Reference must resolve the active Figma library subscription and record importable `libraryKey` / `componentKey` values for every required public component family.
- Final UI must import and instantiate required public Figma components directly from the subscribed library. Recreating public components with frames, rectangles, text, or component-like local fallbacks is forbidden.
- Final UI generates componentized, Auto Layout-backed frames and records evidence in `final-ui-reference.md`.
- Scenario / Quality Check validates screenshot quality plus node-tree maintainability.

Figma component enforcement:
- Final UI must call Figma library discovery for the target file before writing frames.
- If the target file is not subscribed to the required design system library, block `final-ui`, set `blocked_input_request`, and ask the user to add/import the design system library to the target Figma file.
- If a required public component family exists in the adapter but cannot be resolved to an importable `componentKey`, block `design-system-reference` or `final-ui` instead of drawing a replacement.
- Fallbacks are allowed only for product-specific compositions that are explicitly marked as missing from the adapter, such as workflow canvas nodes or condition builders. Fallbacks may compose imported public components, but may not redraw Button, Select, Input, Tag, Banner/Alert, Modal, Popover, Toast, Table, or other listed public families.
- Delivery is not reviewable if required public component families are recreated locally.

Detailed hard gates live in `.codex/skills/final-ui-generation/references/structured-figma-gates.md` and are loaded only during Final UI or Scenario / Quality Check.

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

## Design System Intake

Use `design-system-reference.md` for every UI generation task.

The active adapter is configured in `task-state.json.design_system` and defaults to `content-ecosystem-design`. To swap design systems, add another folder under `.codex/design-systems/<adapter_id>/` with the same adapter files and update `task-state.json.design_system`.

DESIGN.md may be used as source material for the active adapter. It must be absorbed through Design System Intake, not read directly by downstream stages. This keeps the adapter as the workflow authority and preserves progressive disclosure.

Required adapter files:
- `registry.md`
- `component-library-index.md`
- `component-selection-rules.md`
- `foundations.md` when token/style decisions are needed

Optional DESIGN.md source files:
- `source.design.md` or another path recorded in `task-state.json.design_system.design_md_sources`
- a source URL recorded with the same entry when the file was generated or downloaded from a website

DESIGN.md integration rules:
- Treat machine-readable tokens as concrete evidence and markdown prose as application guidance.
- Map DESIGN.md sections into adapter foundations, component selection rules, recipes, and the compact `design-system-reference.md`.
- If a formal Figma/library adapter and DESIGN.md conflict, the adapter wins unless the PRD explicitly asks to explore a new visual direction.
- If DESIGN.md is the primary design source, use the `design-md` adapter and mark missing component families as fallback requirements.
- Downstream stages read `design-system-reference.md` and selected adapter files only; they do not load full DESIGN.md documents by default.

`task-state.json.design_system` records:
- `required`
- `status`: `none`, `missing`, `blocked`, or `summarized`
- `adapter_id`
- `source_file_key`
- `source_url`
- `source_library_name`
- `source_library_key`
- `target_file_subscribed`
- `required_component_keys`
- `missing_component_keys`
- `component_import_policy`
- `artifact`: `projects/<task-id>/current/design-system-reference.md`
- `adapter_registry`
- `component_index_paths`
- `recipe_paths`
- `component_families`
- `design_md_sources`
- `conflict_policy`
- `open_questions`

Final UI is blocked when `design_system.required` is true and `design_system.status` is not `summarized`.
Final UI is also blocked when `design_system.target_file_subscribed` is false, `design_system.source_library_key` is missing, or any required public family is missing an importable `componentKey`.

Downstream stages read the compact design-system artifact and the small number of adapter reference files it points to. Avoid repeatedly loading full Figma library metadata.

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

First-pass delivery requires all non-revision-only stages to be `passing`, required context intake to be summarized, generated Figma evidence to be recorded, and Scenario / Quality Check to report `P0/P1 remaining: 0`.

Revision delivery additionally requires a current `revision-request.md`, routed implementation evidence, changed frame ids when UI changed, affected-scenario QA plus primary-flow regression, and `P0/P1 remaining: 0`.

Use `docs/verification.md` for the full checklist. Load `.codex/skills/final-ui-generation/references/structured-figma-gates.md` only during Final UI generation, Final UI loopback fixes, or Scenario / Quality Check.
