# Vibe Design

AI agent workflow that turns PM PRDs into reviewable Vine UI design artifacts in Figma.

## Prerequisites

Two external tools are needed for the full pipeline:

| Tool | Needed for | Setup |
|---|---|---|
| **lark-cli** | Fetching PRDs from Feishu/Lark URLs | `rules/setup.md §1` |
| **Figma MCP** | Generating Figma frames (`figma-generator`, `design-map-builder`) | `rules/setup.md §2` |

Run `/setup` at any time to check tool status.

## Every Session — Read First

1. Read `SOUL.md` — your identity, behavior principles, and safety red lines.
2. If a task is active: read `projects/<task-id>/current/task-state.json` to know where you left off.
3. **Check Figma MCP every session** — two-level check:

   **Level 1 — connectivity**: attempt `whoami` or any read-only Figma MCP call.
   - ✅ Responds → proceed to Level 2.
   - ❌ Not available → tell the user immediately:
     > ⚠️ **Figma MCP 未配置**，生成 Figma frames 的阶段将无法运行。
     > 现在配置只需一条命令：
     > ```
     > claude plugin install figma@claude-plugins-official
     > ```
     > 安装后重启 Claude Code，然后输入 `/plugin` → Installed → 选 figma → 浏览器授权。
     > 详细步骤：`rules/setup.md §2`
     >
     > 配置完成后回来继续，或直接继续（将在 figma-generator 阶段阻塞）。

   **Level 2 — write access**: if a task is active and `figma.target_url` is set, attempt a minimal `use_figma` call on the target file.
   - ✅ Succeeds → continue silently.
   - ❌ Permission error / 403 → tell the user:
     > ⚠️ **Figma 文件无写入权限**。`figma-generator` 将无法在目标文件中创建 frames。
     > 请确认你对该 Figma 文件有 **Edit** 权限（非 View-only）：
     > Figma 文件 → Share → 将自己的权限改为 Can edit。
4. If `projects/` is empty (no prior tasks), also run `/setup` to surface any other missing configuration.

Full workflow routing: `AGENTS.md` · Complete rule set: `rules/workflow-contract.md`

---

## Two Phases

**Phase A — Foundation Build** (run once per PRD)
PRD → prd-analysis → design-brief → (per story) delivery-spec → figma → QA → design-map → snapshot

**Phase B — Adjustment Loop** (run on PM feedback)
Feedback → Story Attribution → Scope Check → Triage (HOT FIX / SURFACE / ESCALATE)

---

## How to Run

### Normal flow (recommended)

```
/new-task <lark-url>   ← initializes task, then auto-invokes @agent-prd-analyst
```

Phase A proceeds through subagents automatically. Each stage agent runs in its **own isolated context window** — it only sees the files it's allowed to read, nothing from prior conversation turns.

### Manual stage invocation

If you need to re-run a specific stage or resume after a block, invoke the subagent directly:

```
@agent-prd-analyst
@agent-context-scout
@agent-delivery-spec-writer s1
@agent-figma-generator s1
@agent-qa-reviewer s1
@agent-design-map-builder s1
```

### Phase B

```
/phase-b <PM feedback text>
```

---

## Two-Layer Architecture

| Layer | Location | Purpose | Context isolation |
|---|---|---|---|
| **Subagents** | `.claude/agents/*.md` | The 6 stage workers — each runs in its own context window | ✅ Full isolation |
| **Slash commands** | `.claude/commands/*.md` | Orchestration + utilities (`/new-task`, `/phase-b`, `/setup`) | ❌ Runs in main session |

**Rule:** Stage work (prd-analysis, spec writing, Figma generation, QA) always goes through subagents. Slash commands only orchestrate and hand off — they don't do stage work themselves.

---

## Key Locations

```
SOUL.md                            agent identity + safety
AGENTS.md                          workflow routing
rules/workflow-contract.md          authoritative rules
.claude/agents/*.md                subagent definitions (isolated context)
.claude/commands/*.md              slash command orchestrators
.codex/skills/<stage>/SKILL.md     per-stage detailed instructions
projects/<task-id>/current/        active task artifacts
projects/<task-id>/logs/           execution logs
projects/<task-id>/milestones/     immutable snapshots
```
