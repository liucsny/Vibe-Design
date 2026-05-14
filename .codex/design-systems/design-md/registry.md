# DESIGN.md Adapter Registry

## Adapter
- id: `design-md`
- source: DESIGN.md file
- file_key: ``
- file_url: ``
- default_for: Tasks that use a DESIGN.md file as the primary visual design source.

## Source Files
- DESIGN.md: `.codex/design-systems/design-md/source.design.md` when available, or the path recorded in `task-state.json.design_system.design_md_sources`.
- Foundations: `.codex/design-systems/design-md/foundations.md`
- Component index: `.codex/design-systems/design-md/component-library-index.md`
- Selection rules: `.codex/design-systems/design-md/component-selection-rules.md`

## Loading Rule
- Load this registry first.
- Load the DESIGN.md source only during Design System Intake.
- Prefer DESIGN.md token/frontmatter values for exact color, type, spacing, radius, and component styling.
- Use DESIGN.md prose for rationale, atmosphere, motion, responsive behavior, and do/don't guardrails.
- Summarize the task-relevant subset into `projects/<task-id>/current/design-system-reference.md`.
- Downstream stages should read the compact reference and selected adapter files, not the full DESIGN.md source.

## Conflict Rule
- PRD remains the source of truth for product intent and required behavior.
- When DESIGN.md conflicts with task-specific baseline UI, record the conflict and preserve baseline-critical behavior unless the PRD asks for restyling.
- When DESIGN.md is supplemental to a formal Figma adapter, use that formal adapter instead of this adapter.

## Required Evidence
Design System Intake must record:
- source path or URL
- role: `primary`, `supplemental`, or `inspiration`
- token groups captured
- DESIGN.md sections captured
- conflicts and resolution
- fallback components required
