---
name: context-scout
description: Gather design system constraints, UX patterns, and a11y requirements. Synthesize into a shared design-brief.md used by all downstream agents.
---

# Context Scout

## Inputs
- `current/prd.md`
- `current/prd-analysis.json`
- `.codex/design-systems/` — if configured (may be empty)
- `current/task-state.json`

## Output
- `current/design-brief.md`
- Updated `current/task-state.json` (shared.context_scout → passing)
- `logs/02-context-scout.md`

## Steps

### 1. DS Scout Thread — Design System Check

Check `.codex/design-systems/`:
- If a design system is configured (registry.md exists): read `registry.md`, then `component-library-index.md` and `foundations.md`. Identify which components and tokens are available for the PRD's UI requirements.
- If empty or missing: note the gap. Record in the brief: *"Design system not yet configured. Agents should use standard Vine product patterns. No library import constraints apply."*

Regardless of DS status, note:
- What Figma library (if any) should be subscribed to in the target file
- Any component families the PRD requires that are not in the library

### 2. UX Scout Thread — Patterns and Constraints

Based on the PRD's domain (from prd-analysis.json) and user flows:
- Identify the primary interaction patterns (list management, form submission, data visualization, configuration workflow, etc.)
- Note industry conventions for this domain that should be followed
- Identify states that are commonly missed for this domain (e.g., data-heavy → always needs empty state and pagination; workflow → needs step progress indicator)
- Note a11y requirements: keyboard navigation expectations, ARIA roles needed, contrast requirements for any status colors

Do not dump raw research. Synthesize to 3–8 actionable bullet points per section.

### 3. Write design-brief.md

Structure:
```markdown
# Design Brief — <task title>

## Product Context
<1–3 sentences: what is being built and for whom>

## Design System
<DS adapter name and status, or "not configured">
<Key component families available for this PRD>
<Gaps / components to fallback>

## UX Patterns & Conventions
<Bulleted list of patterns that apply to this PRD>
<Anti-patterns to avoid>

## Required States (by surface type)
<List of states that must be generated for each surface category in this PRD>

## Accessibility Constraints
<Specific a11y requirements for this PRD's domain>

## Open Questions
<Design decisions that could not be resolved from the PRD and DS — for PM or design team>
```

The brief must use clear headers so delivery-spec-writer can load only the relevant section (e.g., "## Design System") without reading the full file.

### 4. Update task-state.json
- Set `shared.context_scout` to `passing`.
- If DS is configured, set `figma.library_adapter` to the adapter id.
- Append timeline entry.

### 5. Write Execution Log
Write `logs/02-context-scout.md` using the standard log format from workflow-contract.md §11.
