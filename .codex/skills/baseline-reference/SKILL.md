---
name: baseline-reference
description: Summarize an existing UI baseline from a Figma link or image before PRD-to-UI work, so downstream stages can preserve current design without loading full Figma dumps or raw screenshots repeatedly.
---

# Baseline Reference

Use when a PRD modifies, optimizes, or extends an existing UI, or when the user provides a current Figma link or UI screenshot.

Create a compact baseline summary. Do not redesign UI here.

## When Missing

If the PRD implies existing UI work and no baseline is available, block the active stage with `blocked_input_request`.

Ask for:
- current Figma link or UI screenshot
- optional target frame/page
- optional areas that must not change

## Output

```text
# Baseline Reference

## Source
- type: figma | image | none
- reference:
- target_node:
- screenshot:

## Current UI Summary
- page purpose:
- primary sections:
- key controls:
- current states visible:

## Reuse / Preserve
- layout patterns:
- components:
- terminology:
- visual hierarchy:
- interactions:

## Change Surface
- likely affected areas:
- do-not-change areas:

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

Keep this artifact short. Downstream stages should read `baseline-reference.md`, not full Figma metadata or raw image analysis unless needed.
