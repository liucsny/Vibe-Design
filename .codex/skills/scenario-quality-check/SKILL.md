---
name: scenario-quality-check
description: Validate generated or revised Vine UI against PRD, screenshots, and realistic user scenarios.
---

# Scenario / Quality Check

Inspect screenshots for generated or changed frames. Do not pass from metadata alone.

## Checks

- requirement coverage
- scenario completion
- PM handoff clarity
- visual integrity
- component semantics
- copy quality
- adoption risk

## Severity

```text
P0: missing required surface/flow, impossible scenario, unreadable/broken layout
P1: misleading semantics, unclear state, materially incomplete required copy
P2: minor spacing, hierarchy, density, copy polish
```

P0/P1 blocks delivery and routes to the owning stage:

```text
requirement -> intent-requirement
flow -> flow-spec
missing surface/state/frame -> surface-generation-spec
visual/UI -> final-ui
```

## Revision Mode

When `revision.status == active`:
- read `revision-request.md`
- screenshot changed/versioned frames
- test affected scenarios
- lightly regress the primary PRD flow
- set `revision.status: ready_for_review` only when P0/P1 = 0

## Output

```text
# Scenario / Quality Check

## Scenario Tested
- Scenario:
- Frame/screenshot:
- Result:

## Revision Tested
- revision:
- affected frames:
- affected scenarios:
- regression check:

## Issues
- Severity:
- Evidence:
- Impact:
- Fix:

## Loopback Target

## Required Changes

## Recheck
- Screenshots captured:
- Fixes applied:
- Recheck result:
- P0/P1 remaining:

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```
