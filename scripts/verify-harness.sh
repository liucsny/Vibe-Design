#!/usr/bin/env bash
set -euo pipefail

for file in .codex/agents/*.toml; do
  rg -q '^name = ' "$file"
  rg -q '^developer_instructions = """' "$file"
done
echo "Agent config shape OK"

node -e 'JSON.parse(require("fs").readFileSync("harness/templates/task-state.json", "utf8")); console.log("Template JSON OK")'

node <<'NODE'
const fs = require("fs");
const state = JSON.parse(fs.readFileSync("harness/templates/task-state.json", "utf8"));
const stages = new Map(state.stages.map((stage) => [stage.id, stage]));
for (const id of ["intent-requirement", "flow-spec", "surface-generation-spec", "final-ui", "scenario-quality-check", "revision-request"]) {
  if (!stages.has(id)) throw new Error(`Missing stage: ${id}`);
}
if (!stages.get("revision-request").revision_only) throw new Error("revision-request must be marked revision_only");
if (!state.revision || state.revision.status !== "none") throw new Error("Template revision status must default to none");
if (!state.blocked_input_request || state.blocked_input_request.status !== "none") throw new Error("Template blocked_input_request status must default to none");
console.log("Revision schema OK");
NODE

test -f .codex/agents/revision-manager.toml
test -f .codex/skills/revision-request/SKILL.md
echo "Revision manager files OK"

if rg -n --hidden --glob '!.git' --glob '!scripts/verify-harness.sh' 'task-context|userflow-spec|scenario-quality-review|ui-surface-generation-spec|ui-generation-spec\.md|flow-to-surface-mapping|surface-assembly-spec|ai-interface|self-check' .; then
  echo "Found stale workflow terms." >&2
  exit 1
fi

if find . -name .DS_Store -print | rg .; then
  echo "Found .DS_Store files." >&2
  exit 1
fi

echo "Harness verification OK"
