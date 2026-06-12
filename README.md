# Vibe Design

Vibe Design turns a PM PRD into reviewable Vine UI drafts in Figma, then supports PM feedback as repeatable revisions. See `SOUL.md` for agent identity and principles; see `AGENTS.md` for workflow routing.

## Workflow

### Phase A — Foundation Build

```
┌─────────────────────────────────────────────────────────────────────┐
│  INPUT                                                              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  PRD  (file / pasted text / Lark URL)                       │   │
│  └────────────────────────┬────────────────────────────────────┘   │
│                           │                                         │
│            ╔══════════════▼══════════════╗                          │
│            ║       prd-analyst           ║  → prd-analysis.json    │
│            ╚══════════════╤══════════════╝                          │
│                           │                                         │
│            ╔══════════════▼══════════════╗                          │
│            ║       context-scout         ║  → design-brief.md      │
│            ╚══════════════╤══════════════╝                          │
│                           │                                         │
│              ┌────────────▼─────────────┐                           │
│              │  per story (s1 → s2 …)   │  respects depends_on     │
│              │                          │                           │
│              │  ╔══════════════════╗    │                           │
│              │  ║ delivery-spec-   ║    │  → ui-delivery-spec.md   │
│              │  ║ writer           ║    │                           │
│              │  ╚════════╤═════════╝    │                           │
│              │           │              │                           │
│              │  ╔════════▼═════════╗    │                           │
│              │  ║ figma-generator  ║    │  → final-ui-reference.md │
│              │  ╚════════╤═════════╝    │    + Figma frames         │
│              │           │              │                           │
│              │  ╔════════▼═════════╗    │                           │
│              │  ║  qa-reviewer     ║    │  → scenario-quality-     │
│              │  ╚════════╤═════════╝    │    check.md              │
│              │           │  p0=0 p1=0   │                           │
│              │  ╔════════▼═════════╗    │                           │
│              │  ║ design-map-      ║    │  → design-map.json       │
│              │  ║ builder          ║    │                           │
│              │  ╚══════════════════╝    │                           │
│              └──────────────────────────┘                           │
│                           │                                         │
│              (multi-story) Cross-Story Consistency Check            │
│                           │                                         │
│                    milestones/v0/                                   │
└─────────────────────────────────────────────────────────────────────┘
```

### Phase B — Adjustment Loop

```
  PM Feedback
       │
       ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  TRIAGE                                                         │
  │                                                                 │
  │  SMALL ──────► HOT FIX                                         │
  │  copy, color,   validate Design Map node IDs                   │
  │  spacing        → edit Figma directly                          │
  │                 → update changelog                             │
  │                                                                 │
  │  MEDIUM ─────► SURFACE                                         │
  │  missing state  re-run delivery-spec + figma-generator + QA   │
  │  layout change  for affected surfaces only                     │
  │                                                                 │
  │  LARGE ──────► ESCALATE → re-enter Phase A                    │
  │  new page,      from appropriate stage                         │
  │  new flow                                                      │
  │                                                                 │
  │  NEW SCOPE ──► STOP  ask PM to update PRD first               │
  └───────────────────────────┬─────────────────────────────────────┘
                              │
                         PM Review
                              │
                      milestones/vN/
```

## Repository Layout

```text
SOUL.md                   agent identity, principles, safety red lines
AGENTS.md                 workflow routing, phase rules, context policy

.codex/agents/            one .toml per agent (6 total)
.codex/skills/            one SKILL.md per stage (6 total)
.codex/design-systems/    design system adapters (configure per project)

docs/
  workflow-contract.md    authoritative rules for all agents

harness/templates/
  task-state.json         template for new task state files

scripts/
  init-task-from-prd.sh   initialize a task from PRD (file / text / Lark URL)
  verify-harness.sh       validate harness structure after changes

projects/<task-id>/       one self-contained task
  current/
    prd.md
    prd-analysis.json
    design-brief.md
    changelog.md
    stories/<story-id>/
      ui-delivery-spec.md
      final-ui-reference.md
      scenario-quality-check.md
      design-map.json
  logs/
    01-prd-analysis.md
    02-context-scout.md
    03-delivery-spec-<id>.md
    04-figma-generation-<id>.md
    05-qa-review-<id>.md
    06-design-map-<id>.md
  milestones/
    v0/   (Phase A baseline)
    vN/   (post-PM-review snapshots)

knowledge/
  failure_patterns/       cross-task failure analysis
  quality_cases/          high-quality design case references

PRDs/                     raw PRD files (optional staging area)
```

## Start A Task

```bash
# PRD as Feishu/Lark document
scripts/init-task-from-prd.sh --lark-url "<docx-or-wiki-url>" --title "<short-title>"

# PRD as local file
scripts/init-task-from-prd.sh --file <path> --title "<short-title>"

# PRD pasted in chat
scripts/init-task-from-prd.sh --text "<prd text>" --title "<short-title>"
```

The script creates `projects/<task-id>/` with the standard directory structure, writes `current/prd.md` and `current/task-state.json` from the template, and prints the task ID. Use the generated `task_id` — do not rename it.

If `lark-cli` is missing when using `--lark-url`, the script exits and prints the setup guide.

## Agents

| Agent | Trigger | Artifact |
|---|---|---|
| prd-analyst | New task or PRD change | `prd-analysis.json` |
| context-scout | After prd-analyst passes | `design-brief.md` |
| delivery-spec-writer | After context-scout, per story | `stories/<id>/ui-delivery-spec.md` |
| figma-generator | After delivery-spec passes | `stories/<id>/final-ui-reference.md` + Figma |
| qa-reviewer | After figma-generator passes | `stories/<id>/scenario-quality-check.md` |
| design-map-builder | After qa-reviewer passes | `stories/<id>/design-map.json` |

## Delivery Gate

A story is ready for PM review when:
- `qa_review = passing` with `p0 = 0` and `p1 = 0`
- `design_map = passing`
- All Figma frames are in the named Section

## Verification

After harness changes:

```bash
scripts/verify-harness.sh
```
