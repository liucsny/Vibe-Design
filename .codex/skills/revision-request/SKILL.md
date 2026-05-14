---
name: revision-request
description: Capture PM feedback after a reviewable delivery, classify impact, and route a targeted revision without starting a new PRD task.
---

# Revision Request

Convert PM feedback into a revision execution contract. Do not design UI.

## Impact Levels

```text
final-ui-only      copy, visual, spacing, component state, frame adjustment
surface-change     missing/changed frame, state, content block, action, interaction rule
flow-change        changed path, branch, validation, error state, completion rule
requirement-change changed goal, scope, business rule, data constraint, target user
```

Route to the earliest impacted stage:

```text
requirement-change -> intent-requirement
flow-change        -> flow-spec
surface-change     -> surface-generation-spec
final-ui-only      -> final-ui
```

## Output

```text
# Revision Request

## PM Feedback
- source:
- received_at:
- raw_feedback:

## Atomic Changes
- id:
- request:
- target:
- impact_level:
- routed_stage:
- rationale:

## PRD / Artifact Conflicts

## Revision Scope
- affected_frames:
- affected_artifacts:
- unchanged_artifacts:
- base_frame_ids:
- superseded_frame_ids:

## Execution Contract
- owning_stage:
- required_inputs:
- expected_outputs:
- preserve_existing_frames:
- versioning_rule:
- QA scope:

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

If feedback is too vague to route safely, block `revision-request` with `blocked_input_request`.
