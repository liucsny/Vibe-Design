# Vibe Design

AI agent workflow that turns PM PRDs into reviewable Vine UI design artifacts in Figma.

## Prerequisites

Two external tools are needed for the full pipeline:

| Tool | Needed for | Setup |
|---|---|---|
| **lark-cli** | Fetching PRDs from Feishu/Lark URLs | `docs/setup.md §1` |
| **Figma MCP** | Generating Figma frames (`figma-generator`, `design-map-builder`) | `docs/setup.md §2` |

If a stage blocks due to a missing tool, the agent will print exact setup steps. Run `/setup` at any time to check tool status.

## Every Session — Read First

1. Read `SOUL.md` — your identity, behavior principles, and safety red lines.
2. If a task is active: read `projects/<task-id>/current/task-state.json` to know where you left off.

Full workflow routing: `AGENTS.md`
Complete rule set: `docs/workflow-contract.md`

## Two Phases

**Phase A — Foundation Build** (run once per PRD)
PRD → prd-analysis → design-brief → (per story) delivery-spec → figma → QA → design-map → snapshot

**Phase B — Adjustment Loop** (run on PM feedback)
Feedback → Story Attribution → Scope Check → Triage (HOT FIX / SURFACE / ESCALATE)

## Slash Commands

| Command | When |
|---|---|
| `/new-task` | User gives a PRD — initialize and start Phase A |
| `/prd-analyst` | Phase A ①: analyze PRD, detect stories |
| `/context-scout` | Phase A ②: gather DS + UX context |
| `/delivery-spec [story-id]` | Phase A ③: write UI delivery spec for a story |
| `/figma-generator [story-id]` | Phase A ④: generate Figma frames |
| `/qa-reviewer [story-id]` | Phase A ⑤: QA review with cause_type |
| `/design-map [story-id]` | Phase A ⑥: build Design Map |
| `/phase-b` | Phase B: triage PM feedback |

## Key Locations

```
SOUL.md                            agent identity + safety
AGENTS.md                          workflow routing
docs/workflow-contract.md          authoritative rules
.codex/skills/<stage>/SKILL.md     per-stage instructions
projects/<task-id>/current/        active task artifacts
projects/<task-id>/logs/           execution logs
projects/<task-id>/milestones/     immutable snapshots
```
