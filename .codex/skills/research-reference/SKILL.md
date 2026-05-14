---
name: research-reference
description: Summarize domain background, best practices, and reference products before PRD-to-UI work when the user asks for research or the domain requires current external knowledge.
---

# Research Reference

Use when the user asks for references, best practices, competitive examples, or when the domain is unfamiliar or fast-moving.

Research supplements the PRD; it must not override requirements.

## Source Rules

- Prefer official docs, product docs, primary sources, and reputable case studies.
- Use web search only when needed or explicitly requested.
- Record links and relevance.
- Summarize patterns; do not copy product UI.

## Output

```text
# Research Reference

## Research Goal
- domain:
- why research is needed:

## Sources Reviewed
- title:
- url:
- source type:
- relevance:

## Domain Insights
- user mental model:
- common workflows:
- terminology:
- failure modes:

## Reference Products / Patterns
- product:
- pattern:
- what to learn:
- what not to copy:

## Design Implications
- requirements to reinforce:
- UI patterns to consider:
- risks / anti-patterns:

## Open Questions

## Context Delta
- New decisions:
- New risks:
- New open questions:
- Changes needed:
```

Keep this artifact compact. Downstream stages read `research-reference.md`, not raw search results.
