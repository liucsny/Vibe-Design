# Content Ecosystem Component Selection Rules

## Hard Rules
- Use public components from `component-library-index.md` when a matching family exists.
- Do not import or instantiate any component whose name starts with `_`.
- Do not recreate public components with primitives.
- Do not use Playground components for production UI unless explicitly requested for exploration.
- Record every component family used in `design-system-reference.md` and `final-ui-reference.md`.
- If a public component exists but cannot be imported through Figma MCP, create an Auto Layout-backed local component-like fallback and record the import failure.

## Progressive Disclosure
- First read `registry.md`.
- Then read this file and `component-library-index.md`.
- Load `foundations.md` only for token/style decisions.
- Load recipes only for selected families:
  - `recipes/button.md`
  - `recipes/form-controls.md`
  - `recipes/table.md`
  - `recipes/overlay-feedback.md`
  - `recipes/business-layout.md`
- For a task, choose at most `1-6` component families before creating frames.
- Do not load or inspect every variant in a large component set unless the chosen family needs a specific state.

## Component Family Mapping
- Primary page action: `Button_Solid`
- Secondary action: `Button_Light`
- Low-emphasis or inline action: `Button_Borderless` or `Button_Link`
- Text input: `Text_Input`
- Numeric input: `Number_Input`
- Input with prefix/suffix grouping: `Group_Input`
- Long text or prompt: `TextArea`
- Known option set: `Select`
- Multi-option form choice: `Checkbox`, `CheckboxGroup`, `Radio`, `RadioGroup`
- Immediate on/off setting: `Switch`
- Step or stage progress: `Steps`
- Table/list pagination: `Pagination`
- Confirmation overlay: `Popconfirm` for compact decisions, `Modal` for focused decisions
- Context help/details: `Popover`
- Temporary feedback: `Toast`
- Persistent warning/info: `Banner`
- Status/category metadata: `Status Text`, `Tag/Status`, `Tag/Label`, `Tag/Content Type Label`
- Dense filtering area: `Filter`
- Top or sectional navigation: `Navbar`, `Tabs`
- Right/left contextual navigation: `Sidebar`
- Data tables: `Table`, `Header`, `Column`, `Row`, `Cell`, `Actions Cell`
- Sample/media review: `Sample Card` family

## Fallback Rules
- Fallbacks are allowed only when no public component exists, the component cannot be imported, or the target need is outside the design system.
- Fallbacks must be named `Local/<Family>/<Purpose>`.
- Fallbacks must use Auto Layout.
- Fallbacks must follow Content Ecosystem foundations.
- Fallbacks must be listed in `final-ui-reference.md` with reason and scope.
