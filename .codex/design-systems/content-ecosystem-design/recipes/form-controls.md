# Recipe: Form Controls

## Load When
- The surface contains configuration, filters, side panels, model selection, threshold settings, class selection, or user inputs.

## Public Components
- `Text_Input`: short text values.
- `Number_Input`: numeric values.
- `Group_Input`: input with prefix/suffix or grouped affordance.
- `TextArea`: long text, prompts, notes.
- `Select`: option selection.
- `Checkbox`, `CheckboxGroup`: independent or multi-select choices.
- `Radio`, `RadioGroup`: visible mutually exclusive choices.
- `Switch`: immediate binary settings.

## Hard Rules
- Do not build inputs/selects from loose rectangles and text.
- Use `Select` for known option sets; do not use plain text boxes for selectable model/class/status options.
- Use multi-select behavior only when the product behavior supports multiple values.
- Fixed-width selected values must use truncation for long model names, IDs, URLs, or class groups.
- Full selected values must be available through tooltip, popover, or detail view when truncated.

## Evidence
Record selected public component families, states, and any fallback in `final-ui-reference.md`.
