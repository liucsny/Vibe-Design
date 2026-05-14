# Vine Vibe Design Agent Guide

Before any task:

1. Read `README.md`.
2. Read `docs/workflow-contract.md`.
3. Read `docs/verification.md`.
4. If working on an existing project, check `projects/<task-id>/progress.md` and `projects/<task-id>/session-handoff.md`.
5. For a new PRD, initialize the task yourself. Users should only need to paste the PRD or attach a PRD document.

If the PRD is an attached/local file, derive a short English title and run:

```bash
scripts/init-task-from-prd.sh --file <prd-file> --title "<short-title>"
```

If the PRD is pasted in chat, derive a short English title and run:

```bash
scripts/init-task-from-prd.sh --text "<prd text>" --title "<short-title>"
```

## Core Rules

- PRD is the source of truth.
- The direct upstream artifact is the current stage's execution contract.
- Agents may read PRD and passing upstream artifacts.
- Agents write only their owned artifact plus `task-state.json`.
- Project-specific progress and handoff files live in `projects/<task-id>/`.
- Use the generated `task_id` from `task-state.json`; do not rename it.
- Only one stage may be `active`.
- A stage is `passing` only after its artifact and completion evidence exist.
- If a stage is blocked on missing user input, populate `blocked_input_request` in `task-state.json` and show a concise form-style prompt in chat.
- After the user provides requested input, write it to `task-state.json`, clear `blocked_input_request`, and resume the blocked stage.
- Do not use Vine design skills before Final UI generation or later UI review/fix work.
- Final UI requires Figma MCP and `task-state.json.figma.target_url`.
- Final delivery requires Scenario / Quality Check with `P0/P1 remaining: 0`.
- After delivery, PM feedback must enter the revision loop through `revision-manager`; do not directly patch Figma or upstream artifacts from unstructured feedback.
- Revisions should preserve previous frames by default and create versioned replacement frames unless the user explicitly asks to overwrite.

## Stage Order

```text
intent-requirement
  -> flow-spec
  -> surface-generation-spec
  -> final-ui
  -> scenario-quality-check
```

## Revision Loop

```text
reviewable delivery
  -> revision-request
  -> routed stage:
       final-ui
       surface-generation-spec
       flow-spec
       intent-requirement
  -> scenario-quality-check
  -> new reviewable delivery
```

## Session Exit

Before ending a session, update:
- `projects/<task-id>/progress.md`, if a task is active
- `projects/<task-id>/session-handoff.md`, if a task is active
- the active task's `task-state.json`, if any
