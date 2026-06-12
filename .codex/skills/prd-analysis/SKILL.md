---
name: prd-analysis
description: Parse a PRD into a structured JSON artifact. Detect scope type, story boundaries, quality score, and domain. First stage of Phase A.
---

# PRD Analysis

## Inputs
- `current/prd.md` — the PRD (written by init script)
- `current/task-state.json` — read to confirm stage is active

## Output
- `current/prd-analysis.json`
- Updated `current/task-state.json` (shared.prd_analysis → passing)
- `logs/01-prd-analysis.md`

## Steps

### 1. Read the PRD
Read `current/prd.md` in full. Identify:
- Product goal and user problem being solved
- Feature scope — what is being built
- User roles involved
- Entry points and completion conditions
- Any explicit constraints or non-goals

### 2. Quality Gate
Score the PRD from 1–10 based on:
- Is the main goal clear? (2 pts)
- Are entry and completion conditions defined? (2 pts)
- Are the required UI surfaces identifiable? (2 pts)
- Are edge cases and error states mentioned? (2 pts)
- Is it free of contradictions? (2 pts)

**If score < 6:** Do not continue. List each specific ambiguity that blocks UI work. Ask the user to clarify before proceeding. Set `shared.prd_analysis` to `blocked` in task-state.json.

### 3. Scope Detection
Determine `scope_type`:
- `single_story`: One coherent user flow or feature with a unified UI surface set.
- `multi_story`: PRD contains 2+ clearly distinct feature modules, each with its own UI surfaces and potentially independent user flows.

For `multi_story`, identify each story:
- Assign a short kebab-case id (s1, s2, s3…)
- Give it a descriptive name
- Note which PRD sections it covers
- Identify dependencies (does story B reference UI patterns from story A?)

### 4. Domain Classification
Classify the primary domain:
- `feature-add` — new capability added to existing product
- `revamp` — redesigning an existing UI surface
- `data-heavy` — primary content is tables, charts, or structured data
- `workflow` — multi-step process or pipeline management
- `ai-product` — AI-generated content, model config, or AI-assisted features

### 5. Write prd-analysis.json

```json
{
  "quality_score": 0,
  "quality_notes": "",
  "scope_type": "single_story | multi_story",
  "domain": "feature-add | revamp | data-heavy | workflow | ai-product",
  "product_goal": "",
  "user_roles": [],
  "stories": [
    {
      "id": "s1",
      "name": "",
      "prd_sections": [],
      "depends_on": [],
      "surfaces_hint": []
    }
  ],
  "constraints": [],
  "open_questions": []
}
```

### 6. Update task-state.json
- Set `shared.prd_analysis` to `passing`.
- If multi_story: populate the `stories` array with all detected stories (id, name, depends_on).
- Append a timeline entry: `{ "stage": "prd_analysis", "status": "passing", "at": "<ISO timestamp>" }`.

### 7. Write Execution Log
Write `logs/01-prd-analysis.md` using the standard log format from workflow-contract.md §11.
