# DESIGN.md Foundations Mapping

Use this adapter when DESIGN.md is the primary source for visual language.

## Source Shape
DESIGN.md can contain:
- optional YAML frontmatter with machine-readable tokens
- markdown sections with human-readable rationale and usage guidance

Expected token groups:
- `colors`
- `typography`
- `spacing`
- `rounded`
- `components`

Expected markdown sections:
- `Overview` or `Brand & Style`
- `Colors`
- `Typography`
- `Layout` or `Layout & Spacing`
- `Elevation & Depth` or `Elevation`
- `Shapes`
- `Components`
- `Do's and Don'ts`

getdesign-style outputs may also include:
- visual theme and atmosphere
- color palette with semantic roles
- components with measured properties
- motion timing, easing, and transforms
- responsive behavior
- prompt guide for matching UI

## Mapping Rules
- Map colors to semantic usage roles before exposing them downstream.
- Map typography into display, heading, body, label, and caption roles when possible.
- Map spacing into a compact scale and note whether the design feels dense, balanced, or spacious.
- Map radius into shape language, not just numeric values.
- Map elevation into shadows, borders, tonal layers, or flat hierarchy rules.
- Map component tokens and prose into public component families and fallback requirements.
- Map motion and responsive behavior into Final UI guidance only when relevant to the requested surfaces.

## Hard Rules
- Do not invent a Figma component library from DESIGN.md. If no public component exists, record a fallback requirement.
- Do not preserve one-off CSS values unless they represent a repeated token or a deliberate exception.
- Do not let inspiration-brand specifics override the PRD's product domain, data model, or content needs.
- Keep the final `design-system-reference.md` compact enough for downstream stages to read in full.
