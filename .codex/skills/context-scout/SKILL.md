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

### 3. Design Research Trigger Assessment

After completing the DS and UX Scout threads, score the task against the following criteria. Each criterion that applies adds 1 point:

| Criterion | Signal |
|---|---|
| 2 or more custom components (no DS equivalent, requires novel frame) | From DS Scout gaps list |
| Domain is `ai-product` or `data-heavy` | From prd-analysis.json |
| PRD quality score < 7 | From prd-analysis.json |
| 3 or more novel interaction patterns not covered by standard Vine conventions | From UX Scout findings |
| Multi-story PRD with 3+ stories | From prd-analysis.json |

**If score ≥ 2 → run Design Research (Step 3a).**
**If score < 2 → skip to Step 4.**

Record the score and the triggered criteria in the execution log and in the `## Design Research` section of the brief (even if research was skipped, note "Research not triggered — score: N/5").

### 3a. Design Research (conditional)

Run only when triggered. Research is targeted — do not do general background reading. Focus only on the specific gaps identified in Steps 1 and 2.

**Research scope — address each of the following that applies:**

1. **Novel component patterns:** For each custom component identified in DS Scout (e.g. diff viewer, prompt editor with toolbar, token estimator), search for 2–3 real-world implementations. Describe: layout structure, key interaction states, common conventions, pitfalls to avoid.

2. **Domain-specific conventions:** For the PRD's domain (e.g. ai-product, data-heavy, workflow), identify conventions that are not obvious from general UI knowledge — e.g. how LLM output is typically displayed, how batch job status is typically surfaced, how configuration panels are typically structured for ML tools.

3. **Complex flow patterns:** For any multi-step loops or non-linear flows identified in UX Scout, research how similar flows are handled in comparable products. Focus on error recovery, progressive disclosure, and confirmation gate patterns.

**Output format for each research finding:**

```
### [Component or Pattern Name]
- **Common implementations:** [2–3 examples with description, no URLs needed]
- **Key conventions:** [bullet list of what's standard]
- **Recommended approach for this PRD:** [1–2 sentences — a specific recommendation, not a survey]
- **Pitfalls to avoid:** [bullet list]
```

Synthesize — do not dump raw notes. Each finding must end with a "Recommended approach" that delivery-spec-writer can act on directly.

### 4. Write design-brief.md

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

## Design Research
<Score: N/5. Triggered: yes/no. If yes: structured findings per component/pattern.>
<If not triggered: "Research not triggered — score: N/5. Standard Vine patterns apply.">

## Open Questions
<Design decisions that could not be resolved from the PRD and DS — for PM or design team>
```

The brief must use clear headers so delivery-spec-writer can load only the relevant section (e.g., "## Design System") without reading the full file.

### 5. Update task-state.json
- Set `shared.context_scout` to `passing`.
- If DS is configured, set `figma.library_adapter` to the adapter id.
- Append timeline entry.

### 6. Write Execution Log
Write `logs/02-context-scout.md` using the standard log format from workflow-contract.md §11. Include: research trigger score, criteria that fired, and (if triggered) a one-line summary of each research finding.
