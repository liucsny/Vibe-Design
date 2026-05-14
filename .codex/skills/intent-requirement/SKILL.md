---
name: intent-requirement
description: Extract a concise Intent / Requirement artifact from a PRD, brief, or feature request. Usually invoked by `design-workflow-orchestrator` as the first artifact step in a PRD-to-UI workflow.
---

# Intent Requirement

**Dual-Core Input Philosophy:**
- **Core Input 1 (Anchor & Contract):** The PRD. Since this is the first stage, the PRD serves as both the original North Star and the direct execution contract.
- **Auxiliary Inputs:** Use `task-state.json`, `baseline-reference.md`, or `research-reference.md` only as supporting context to clarify constraints or terminology.

Turn the PRD into the first workflow artifact. Keep it short, PRD-derived, and explicit about uncertainty.

Ask for clarification only when the main goal, entry point, completion outcome, or gating rule is too unclear to proceed. Otherwise continue and record open questions.

In revision mode, use `revision-request.md` only for routed requirement-level changes. Preserve unchanged requirements and record PM feedback conflicts with the PRD.

If `baseline-reference.md` exists, distinguish new/changed requirements from current UI behavior to preserve.
If `research-reference.md` exists, use it only to clarify domain terminology, user mental model, and risks; do not override the PRD.

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

## Baseline Context
- existing UI:
- preserve:
- change surface:

## Research Context
- domain insights:
- reference patterns:
- implications:

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
