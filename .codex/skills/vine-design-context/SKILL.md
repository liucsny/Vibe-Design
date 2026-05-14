---
name: vine-design-context
description: Vine-specific design context for Final UI generation or later UI review/fix work. Do not use for Intent / Requirement, Flow Spec, or Surface Generation Spec.
---

# Vine Design Context

Use only during:
- `final-ui`
- `scenario-quality-check`
- `final-ui` loopback fixes

Purpose: keep generated UI aligned with existing Vine product patterns.

## Priority Sources

Use sources in this order:
1. current task `design-system-reference.md`
2. active design system adapter under `.codex/design-systems/<adapter_id>/`
3. current Vine Figma pages or node references
4. current Vine screenshots or exported reference images
5. `references/page-inventory.md`
6. `references/product-patterns.md`
7. `references/component-guidelines.md`
8. `references/design-principles.md`

## Rules

- Reuse existing Vine page structures before inventing new ones.
- Reuse public components from the active design system adapter before creating local component-like fallbacks.
- Keep object identity, status, version, and primary action visible.
- Prefer task-oriented, information-dense B-end layouts.
- Record missing or weak references as assumptions or gaps.
- If screenshots and Figma conflict, use the more current source when known; otherwise call out the ambiguity.
- Do not use adapter-internal components directly. For the default Content Ecosystem adapter, component names starting with `_` are internal-only.

## Output Expectations

When this skill influences UI, record:
- reused page or pattern
- active design system adapter and public component families used
- consistency constraints
- new pattern rationale, if any
- unresolved Vine-specific assumptions
