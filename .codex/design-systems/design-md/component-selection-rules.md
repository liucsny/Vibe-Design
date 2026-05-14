# DESIGN.md Component Selection Rules

## Authority
- PRD defines required product behavior and content.
- Existing baseline UI defines preservation needs when present.
- DESIGN.md defines visual language only.
- Adapter summaries in `design-system-reference.md` are what downstream stages consume.

## Selection Rules
- Use a formal Figma/library adapter when one is configured and accessible.
- Use this `design-md` adapter when DESIGN.md is the primary available design system source.
- Select only component families needed by the current surface.
- Convert repeated DESIGN.md patterns into fallback component requirements.
- Prefer explicit tokens over prose when both exist.
- Use prose to resolve tone, hierarchy, component emphasis, and do/don't guardrails.

## Conflict Handling
- If token values and prose disagree, tokens win and the conflict is recorded.
- If DESIGN.md and baseline UI disagree, preserve baseline behavior and record visual changes required by the PRD.
- If DESIGN.md and a formal adapter disagree, the formal adapter wins unless the PRD explicitly asks for the DESIGN.md visual direction.

## Fallback Requirements
For every missing public component family, record:
- missing family
- fallback name
- reason
- required structure
- token/style rules to apply
- states that must be represented

## Do Not
- Do not list DESIGN.md prose as an importable component.
- Do not create brand-specific decorative elements unless the PRD asks for that visual direction.
- Do not pass full raw DESIGN.md to Final UI by default.
