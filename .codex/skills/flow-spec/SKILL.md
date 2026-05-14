---
name: flow-spec
description: Create a Flow Spec from an Intent / Requirement artifact, PRD, and task context. Usually invoked by `design-workflow-orchestrator` after Intent / Requirement in a PRD-to-UI workflow.
---

# Flow Spec

**Dual-Core Input Philosophy:**
- **Core Input 1 (Anchor):** The PRD. Use this to ensure the flow achieves the original business goal and user intent.
- **Core Input 2 (Contract):** The `intent-requirement.md` artifact. This is your direct execution contract.
- **Auxiliary Inputs:** Use `task-state.json`, `baseline-reference.md`, or `research-reference.md` only as supporting context. DO NOT load older passing artifacts unless there is a specific data gap blocking you.

Define how the user completes the task. Focus on actions, branches, and state transitions. Do not choose layout or components.

In revision mode, use `revision-request.md` only for routed flow-level changes. Preserve unchanged flow behavior and record any requirement conflict instead of inventing new scope.

If `baseline-reference.md` exists, model only affected flow changes and preserve unchanged baseline paths.
If `research-reference.md` exists, use it for domain workflows, terminology, and failure modes.

Use this structure:

```text
# Flow Spec

## User Goal

## Entry Point

## Main Path

## Branches

## Empty / Error / Permission States

## Completion / Exit

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

Do not force page or frame decisions unless they are necessary to explain the flow.
