# Structured Figma Gates

Load this reference only during Final UI generation, Final UI revision, or Scenario / Quality Check.

## Design System Gate

- `design-system-reference.md` must exist when `task-state.json.design_system.required` is true.
- `task-state.json.design_system.status` must be `summarized` before Final UI starts.
- Load only the active adapter registry, component index, selection rules, and selected recipes.
- Do not load a full Figma library metadata dump into context.
- Relevant public component families must be imported/instantiated, or an import/access failure must be recorded.
- Internal components identified by the adapter must not be used directly. In the default adapter, names starting with `_` are internal-only.
- `final-ui-reference.md` must record adapter id, source file key, loaded adapter files, recipe files, public component names/keys/node ids, internal exclusions, and fallback reasons.

## Structure Gate

- Each generated screen must include `Page Header` and `Body` containers unless it is explicitly modal-only or component-only.
- Each generated screen must have `8` or fewer direct child nodes, excluding documented overlays and review-only labels.
- `Page Header`, `Body`, main content regions, sidebars, panels, form groups, table/list rows, modal content, modal actions, and repeated control groups must use Auto Layout (`layoutMode != NONE`).
- UI patterns repeated `2` or more times must be component instances, local component instances, or named Auto Layout component-like frames with the same child structure.
- Button, Input, Select, Tag, Alert, Modal, Table Row, Metric Field, Workflow Node, Toolbar Action, and Empty/Error State must not be loose rectangle/text sibling primitives.
- Primitive exceptions are allowed only for dividers, overlays, connectors, simple media placeholders, and one-off visual marks.
- `final-ui-reference.md` must record direct child count, Auto Layout container names/counts, repeated pattern reuse, primitive exceptions with node id/reason/scope, and fallback limitations.

## Text Gate

- Every text node must use an intentional mode:
  - Auto width: `textAutoResize = "WIDTH_AND_HEIGHT"`
  - Auto height: `textAutoResize = "HEIGHT"`
  - Fixed size: `textAutoResize = "NONE"`
- Use Auto width for short intrinsic labels: button labels, tag labels, short status text, icon labels, menu item labels, table header labels, compact metadata labels.
- Use Auto height for wrapped copy in constrained width: descriptions, helper text, alert copy, modal body copy, empty/error explanations, tooltip/popover body text, multi-line table content.
- Use Fixed size only for fixed UI slots: table/list cells, select/input displayed values, fixed-card titles, sidebar item titles, workflow node titles, nav items, KPI/metric labels.
- Single-line fixed-width text that can overflow must use truncation. Required cases: table/list cells, selected values, card/sidebar/workflow node titles, dependency/model/feature names, file names, URLs, IDs, breadcrumbs/nav items.
- Multi-line fixed-height text must define a maximum line count and use truncation or documented overflow behavior.
- Truncated decision-critical values must expose the full value through tooltip, popover, detail drawer, or linked detail view.
- `final-ui-reference.md` must record Auto width / Auto height / Fixed size counts, truncation-enabled text node ids, field names, overflow exceptions, and full-value reveal behavior.

## QA P1 Failures

Scenario / Quality Check must fail with P1 when any of these occur:
- missing `design-system-reference.md` while required
- missing design system evidence in `final-ui-reference.md`
- public adapter component redrawn with primitives without recorded import/access failure
- internal adapter component used directly
- screen direct child count exceeds `8` without documented exception
- required semantic containers are missing
- required major container has `layoutMode: NONE`
- key controls are built from loose sibling primitives
- repeated pattern appears `2` or more times without component/component-like reuse
- primitive exception records are missing
- visible text clipping
- overflow-prone fixed-width text lacks truncation
- fixed-height multi-line text lacks max-line plus truncation/overflow strategy
- textAutoResize counts/truncation evidence are missing
- truncated decision-critical value lacks full-value reveal behavior
