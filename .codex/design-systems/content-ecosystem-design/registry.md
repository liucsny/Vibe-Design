# Content Ecosystem Design Registry

## Adapter
- id: `content-ecosystem-design`
- source: Figma library
- file_key: `gYZObm5AoqSEwYDfclY4HJ`
- file_url: https://www.figma.com/design/gYZObm5AoqSEwYDfclY4HJ/Content-Ecosystem-Design
- default_for: Vine / Content Ecosystem UI generation

## Pages
- Style Doc: `148:2214`
- Basic: `173:1069`
- Business: `16:2`
- Util: `375:14107`
- Icons: `301:10183`
- Playground: `111:3235`

## Loading Rule
- Load this registry first.
- Load `component-library-index.md` before searching or importing components.
- Load `component-selection-rules.md` before Final UI generation.
- Load `foundations.md` only when colors, text styles, spacing, radius, or effects are needed.
- Load at most `1-4` files under `recipes/` that match the current task.
- Do not load full Figma metadata dumps into the UI agent context.

## Public Component Rule
- Components whose names start with `_` are internal-only.
- Internal components must not be imported, instantiated, or listed as usable components in final UI work.
- Use the nearest public parent component instead.
- If no public component exists, create a local Auto Layout-backed component-like fallback and record the gap.

## Required Evidence
Final UI and QA artifacts must record:
- adapter id
- file key
- component families loaded
- public component names/keys used
- internal component exclusions, if encountered
- fallback components and reasons
