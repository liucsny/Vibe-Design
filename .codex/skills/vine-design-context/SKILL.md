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
1. current Vine Figma pages or node references
2. current Vine screenshots or exported reference images
3. `references/page-inventory.md`
4. `references/product-patterns.md`
5. `references/component-guidelines.md`
6. `references/design-principles.md`

## Rules

- Reuse existing Vine page structures before inventing new ones.
- Keep object identity, status, version, and primary action visible.
- Prefer task-oriented, information-dense B-end layouts.
- Record missing or weak references as assumptions or gaps.
- If screenshots and Figma conflict, use the more current source when known; otherwise call out the ambiguity.

## Output Expectations

When this skill influences UI, record:
- reused page or pattern
- consistency constraints
- new pattern rationale, if any
- unresolved Vine-specific assumptions
