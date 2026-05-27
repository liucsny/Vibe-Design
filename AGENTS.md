# Vine Vibe Design Agent Guide

Before any task:

1. Read `README.md` for the workflow map and context loading policy.
2. Read only the relevant section of `docs/workflow-contract.md` for the active stage or decision.
3. Read `docs/verification.md` only before delivery, QA, harness edits, or gate debugging.
4. If working on an existing project, check `projects/<task-id>/progress.md` and `projects/<task-id>/session-handoff.md`.
5. For a new PRD, initialize the task yourself. Users should only need to paste the PRD, attach a PRD document, or provide a Feishu/Lark document link.

If the PRD is an attached/local file, derive a short English title and run:

```bash
scripts/init-task-from-prd.sh --file <prd-file> --title "<short-title>"
```

If the PRD is pasted in chat, derive a short English title and run:

```bash
scripts/init-task-from-prd.sh --text "<prd text>" --title "<short-title>"
```

If the PRD is a Feishu/Lark docx or wiki link, derive a short English title and run:

```bash
scripts/init-task-from-prd.sh --lark-url "<docx-or-wiki-url>" --title "<short-title>"
```

The script fetches the document through `lark-cli docs +fetch --api-version v2`, writes the fetched Markdown to `current/prd.md`, and records the original URL in `task-state.json`.

## Core Rules

- **Dual-Core Alignment**: PRD is the "North Star" (source of truth) and the direct upstream artifact is the "Execution Contract". These are the primary inputs for any stage.
- Agents read the PRD, direct upstream artifact, current `task-state.json`, and summarized context artifacts first.
- **Hard Constraint for Older Artifacts**: Agents MUST NOT load older passing artifacts by default. Older passing artifacts (e.g., loading `intent-requirement.md` during `final-ui`) MAY ONLY be loaded if the direct upstream artifact contains explicit ambiguities, missing data references, or contradictions that block the current stage's execution. If loaded, it must strictly be used to resolve the specific data gap (fidelity check) and must not be used to bypass the upstream artifact's instructions.
- Agents write only their owned artifact plus `task-state.json`.
- Project-specific progress and handoff files live in `projects/<task-id>/`.
- Use the generated `task_id` from `task-state.json`; do not rename it.
- Only one stage may be `active`.
- A stage is `passing` only after its artifact and completion evidence exist.
- If a stage is blocked on missing user input, populate `blocked_input_request` in `task-state.json` and show a concise form-style prompt in chat.
- After the user provides requested input, write it to `task-state.json`, clear `blocked_input_request`, and resume the blocked stage.
- If a PRD modifies an existing UI, request or use a current Figma link/screenshot and summarize it in `baseline-reference.md`; downstream agents should read the summary, not raw baseline dumps, unless needed.
- If a task needs background knowledge, references, best practices, or current external examples, summarize research in `research-reference.md`; downstream agents should read the summary, not raw search results, unless fresh verification is needed.
- Baseline and research are independent optional Context Intake artifacts; one does not exclude the other.
- Do not use Vine design skills before Final UI generation or later UI review/fix work.
- Final UI requires Figma MCP and `task-state.json.figma.target_url`.
- Final delivery requires Scenario / Quality Check with `P0/P1 remaining: 0`.
- After delivery, PM feedback must enter the revision loop through `revision-manager`; do not directly patch Figma or upstream artifacts from unstructured feedback.
- Revisions should preserve previous frames by default and create versioned replacement frames unless the user explicitly asks to overwrite.

## Context Loading

- Load the active stage skill only; do not preload every skill.
- Use `baseline-reference.md`, `research-reference.md`, and `design-system-reference.md` as compressed context. Avoid raw Figma dumps, screenshots, or web results unless the active stage truly needs them.
- Load Vine design skills only during Final UI generation, Scenario / Quality Check, or later UI review/fix work.
- Load detailed references, such as `structured-figma-gates.md` or adapter recipes, only when the current stage names them as required.
- Keep `progress.md` and `session-handoff.md` short: current state, next action, blockers, and latest evidence only.

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
