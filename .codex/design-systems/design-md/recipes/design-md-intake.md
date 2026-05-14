# DESIGN.md Intake Recipe

Use this recipe when summarizing a DESIGN.md source into `design-system-reference.md`.

## Steps
1. Identify the source path, URL, role, and generation method if known.
2. Capture token groups from YAML frontmatter when present.
3. Capture relevant markdown sections and ignore unrelated prose.
4. Map tokens into foundations: colors, typography, spacing, radius, elevation, motion, responsive behavior.
5. Map component guidance into public component families or fallback requirements.
6. Record conflicts against PRD, baseline, or a formal adapter.
7. Keep only task-relevant guidance in the final compact artifact.

## Output Notes
- Include exact token values only when they are likely to be used in Final UI.
- Summarize atmosphere and do/don't rules in short action-oriented bullets.
- Record missing details as open questions only when they block Final UI quality.
