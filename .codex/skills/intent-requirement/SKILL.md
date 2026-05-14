---
name: intent-requirement
description: Extract a concise Intent / Requirement artifact from a PRD, brief, or feature request. Usually invoked by `design-workflow-orchestrator` as the first artifact step in a PRD-to-UI workflow.
---

# Intent Requirement

Turn the PRD into the first workflow artifact. Keep it short, PRD-derived, and explicit about uncertainty.

Ask for clarification only when the main goal, entry point, completion outcome, or gating rule is too unclear to proceed. Otherwise continue and record open questions.

In revision mode, use `revision-request.md` only for routed requirement-level changes. Preserve unchanged requirements and record PM feedback conflicts with the PRD.

## Output

Use this structure:

```text
# Intent / Requirement

## PRD Quality
- score:
- rationale:

## Scope Decision
- type: clarification needed / single flow / multi-flow
- rationale:

## Target User

## Core Task

## Entry / Completion
- entry point:
- completion outcome:

## Success Criteria

## Constraints From PRD

## Flow Candidates
- primary flow:
- supporting flows:

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

Do not invent missing constraints or references.
Do not produce Flow Spec details, UI structure, layout, styling, or component suggestions.
