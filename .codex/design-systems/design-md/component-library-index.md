# DESIGN.md Component Library Index

This adapter does not provide imported Figma components by default. It converts DESIGN.md component guidance into task-specific fallback requirements.

## Public Component Families

### Buttons
- source: DESIGN.md `Components`, `Colors`, `Typography`, `Shapes`
- usage: primary, secondary, tertiary, destructive, icon-only, loading, disabled
- fallback: create Auto Layout-backed button instances using summarized tokens

### Inputs And Form Controls
- source: DESIGN.md `Components`, `Typography`, `Elevation & Depth`, `Shapes`
- usage: text input, textarea, select, checkbox, radio, switch, validation states
- fallback: create accessible, labeled Auto Layout-backed controls

### Cards And Containers
- source: DESIGN.md `Layout`, `Elevation & Depth`, `Shapes`
- usage: content grouping, metric panels, list rows, object summaries
- fallback: use tokenized surfaces, borders, radius, and spacing

### Navigation
- source: DESIGN.md `Layout`, `Components`, `Responsive Behavior`
- usage: tabs, sidebar, top bar, breadcrumbs, pagination
- fallback: build compact navigation with clear selected, hover, and disabled states

### Tables And Lists
- source: DESIGN.md `Typography`, `Layout`, `Components`
- usage: dense data, comparison, row actions, empty states
- fallback: preserve scanability and truncation behavior

### Feedback And Overlays
- source: DESIGN.md `Colors`, `Elevation & Depth`, `Components`
- usage: toast, tooltip, modal, popover, alert, confirmation
- fallback: record exact missing family and build local component-like frames

## Internal Component Rule
- DESIGN.md has no importable internal Figma components.
- If a source references private or brand-specific components, translate only the observable design rule and record it as a fallback requirement.
