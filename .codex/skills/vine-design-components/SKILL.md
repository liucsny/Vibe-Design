---
name: vine-design-components
description: Vine component guidance for Final UI generation or later UI review/fix work. Do not use for Intent / Requirement, Flow Spec, or Surface Generation Spec.
---

# Vine Design Components

Choose components by task semantics, then map to the closest available Figma / Semi / Vine component. If no reliable component exists, record the gap in `final-ui-reference.md`.

## Active Design System Adapter

Use the active adapter from `task-state.json.design_system` and `design-system-reference.md`.

Default adapter:
- `.codex/design-systems/content-ecosystem-design/`

Before choosing components:
- read the task `design-system-reference.md`
- read the adapter `component-library-index.md`
- read the adapter `component-selection-rules.md`

Hard rules:
- Use public adapter components when a matching family exists.
- Do not use components whose names start with `_`; they are internal-only in the default Content Ecosystem adapter.
- Do not redraw public components with primitives.
- If a public component cannot be imported, create an Auto Layout-backed local component-like fallback and record the reason.

## Global Rules

- Preserve action hierarchy.
- Prefer reusable Vine components over ad hoc layout pieces.
- Show loading, disabled, empty, error, read-only, and selected states when the flow can reach them.
- Do not use visual style to imply unsupported behavior.

## High-Frequency Components

### Button

Use buttons for explicit actions.

Hierarchy:
1. `Button_Solid / Primary`: strongest page action, usually one per page.
2. `Button_Light / Primary`: important supporting action.
3. `Button_Borderless / Primary`: low-emphasis action.
4. `Button_Light / Secondary`: cancel/back/rollback action.
5. `Button_Link / Primary`: lightweight navigation or download.

See `references/button.md` for detailed variants.

### Input

Use Input for short text, search, email, password, and numbers. Pair standard form inputs with visible labels.

See `references/input.md` for detailed states and validation.

### Select

Use Select for known option sets. Use searchable Select for long, remote, or user-specific options.

Rules:
- show readable labels, not raw ids
- use multi-select only when supported by the task
- include loading, empty, disabled, and error states when options may be unavailable

### Checkbox / Radio / Switch

- Checkbox: independent binary choices or multi-select lists.
- Radio: mutually exclusive choices that should be visible at once.
- Switch: immediate on/off settings that do not require Save.

Use confirmation for risky switches that affect production, cost, publishing, or permissions.

### Tag

Use Tag for status, category, ownership, version, risk, or metadata. Do not make tags look like buttons unless they are interactive.

### Dropdown

Use Dropdown for secondary, overflow, or compact action menus. Never hide the page's primary action inside a dropdown.

### TextArea

Use TextArea for prompts, descriptions, instructions, and review notes. Show limits and validation when relevant.

### Modal

Use Modal for focused blocking decisions or short forms. Do not put large multi-step workflows in a modal.

### Side Sheet

Use Side Sheet for contextual create/edit/inspect/review flows that should keep the page in context.

### Tooltip / Popover

Use Tooltip for short explanations. Use Popover for small interactive contextual content. Do not hide required warnings only in tooltips.
