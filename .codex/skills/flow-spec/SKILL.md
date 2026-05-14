---
name: flow-spec
description: Create a Flow Spec from an Intent / Requirement artifact, PRD, and task context. Usually invoked by `design-workflow-orchestrator` after Intent / Requirement in a PRD-to-UI workflow.
---

# Flow Spec

Define how the user completes the task. Focus on actions, branches, and state transitions. Do not choose layout or components.

In revision mode, use `revision-request.md` only for routed flow-level changes. Preserve unchanged flow behavior and record any requirement conflict instead of inventing new scope.

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
