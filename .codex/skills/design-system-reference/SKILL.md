---
name: design-system-reference
description: Summarize the active design system adapter for a task into a compact design-system-reference.md artifact before Final UI generation, using adapter indexes, optional DESIGN.md source material, and only task-relevant components.
---

# Design System Reference

Use when a PRD-to-UI workflow needs to generate or revise Figma UI.

This skill is a Context Intake artifact. It decouples the workflow from any single design system by converting the configured design system adapter into a compact task-specific reference. DESIGN.md files can be used as adapter source material, but downstream stages should still consume the compact artifact rather than full raw DESIGN.md content.

## Inputs

Read:
- `task-state.json.design_system`
- active adapter registry under `.codex/design-systems/<adapter_id>/`
- optional DESIGN.md files listed by the adapter registry or `task-state.json.design_system.design_md_sources`
- `surface-generation-spec.md` when available
- `baseline-reference.md` when present

Default adapter:
- `content-ecosystem-design`

## Hard Rules

- Do not paste raw Figma metadata dumps into this artifact.
- Read `registry.md` first.
- Read `component-library-index.md` and `component-selection-rules.md`.
- Load `foundations.md` only if the task needs token/style decisions.
- Load full DESIGN.md source only during this intake stage or when explicitly routed back to design-system-reference.
- Treat DESIGN.md machine-readable token/frontmatter values as evidence; treat markdown body prose as usage guidance.
- Normalize DESIGN.md content into adapter concepts: foundations, component families, selection rules, fallback requirements, and recipes.
- If DESIGN.md and the formal adapter conflict, prefer the adapter unless the PRD explicitly requests a new visual direction.
- Load at most `1-4` adapter recipe files that match the current task.
- Select only task-relevant component families.
- Components whose names start with `_` are internal-only and must not be listed as usable components.
- If a required family has no public component, record a fallback requirement.
- For every required public component family, resolve importable Figma component metadata:
  - call Figma library discovery for the target file when a target file exists
  - verify that the active design system library is subscribed to the target file
  - use scoped design-system search with the resolved `libraryKey`
  - record `libraryKey`, `componentKey`, `assetType`, and component name for every required public component
- Do not mark the design system as `summarized` if required public components exist but their importable `componentKey` values are missing.
- If the target Figma file is not subscribed to the required library, mark status `blocked` and populate `blocked_input_request` asking the user to add/import the library to the target file.
- If Figma MCP cannot access the adapter file, mark design system status `missing` or `blocked` and block Final UI.

## Output

Write:

```text
projects/<task-id>/current/design-system-reference.md
projects/<task-id>/current/task-state.json
```

Use this structure:

```text
# Design System Reference

## Adapter
- id:
- source:
- file_key:
- file_url:
- library_name:
- library_key:
- target_file_subscribed: true / false / unknown
- status: summarized / missing / blocked

## Pages / Sources Used
- registry:
- component index:
- selection rules:
- foundations:
- DESIGN.md sources:
- figma nodes inspected:

## DESIGN.md Source Summary
- source:
- role: primary / supplemental / inspiration
- tokens captured:
- sections captured:
- mapped to adapter files:
- conflicts with adapter:
- conflict resolution:

## Task-Relevant Component Families
- family:
- public components:
- node ids:
- library key:
- component keys:
- asset types:
- usage:
- required variants/states:

## Excluded Internal Components
- rule:
- examples encountered:

## Foundations To Apply
- variables:
- text styles:
- paint styles:
- effects:
- spacing:
- radius:

## Component Selection Rules For This Task
- must use:
- must not use:
- fallback allowed when:
- import policy:

## Fallback Requirements
- missing family:
- fallback name:
- reason:
- required structure:

## Progressive Disclosure Plan
- load first:
- load only if needed:
- recipes selected:
- do not load:

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

Update `task-state.json.design_system`:
- `required: true`
- `status: summarized | missing | blocked`
- `adapter_id`
- `source_file_key`
- `source_url`
- `source_library_name`
- `source_library_key`
- `target_file_subscribed`
- `required_component_keys`
- `missing_component_keys`
- `component_import_policy`
- `artifact`
- `component_families`
- `component_index_paths`
- `recipe_paths`
- `design_md_sources`
- `conflict_policy`
- `open_questions`
