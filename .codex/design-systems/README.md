# Design System Adapters

Design system adapters keep the workflow decoupled from any single Figma library.

Each adapter folder must provide:
- `registry.md`: source Figma file/page ids, scope, and loading rules.
- `foundations.md`: tokens, text styles, spacing, radius, shadows, and hard usage notes.
- `component-library-index.md`: public component families with links and usage boundaries.
- `component-selection-rules.md`: hard rules for choosing components, excluding internal components, and fallback behavior.
- `recipes/`: optional small task-specific usage notes loaded only when that component family is needed.

Workflow stages should read only the active adapter index first, then load the small number of component details needed for the current task. Do not paste raw Figma dumps into stage context.

Default adapter:
- `content-ecosystem-design`
