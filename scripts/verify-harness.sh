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
if (!state.baseline || state.baseline.status !== "none") throw new Error("Template baseline status must default to none");
if (state.baseline.artifact !== "projects/<task-id>/current/baseline-reference.md") throw new Error("Template baseline artifact path is invalid");
if (!state.research || state.research.status !== "none") throw new Error("Template research status must default to none");
if (state.research.artifact !== "projects/<task-id>/current/research-reference.md") throw new Error("Template research artifact path is invalid");
if (!state.design_system || state.design_system.status !== "none") throw new Error("Template design_system status must default to none");
if (!state.design_system.required) throw new Error("Template design_system.required must default to true");
if (!state.design_system.adapter_id) throw new Error("Template design_system.adapter_id is missing");
if (state.design_system.artifact !== "projects/<task-id>/current/design-system-reference.md") throw new Error("Template design_system artifact path is invalid");
if (!Array.isArray(state.design_system.component_index_paths)) throw new Error("Template design_system.component_index_paths must be an array");
if (!Array.isArray(state.design_system.recipe_paths)) throw new Error("Template design_system.recipe_paths must be an array");
if (!Array.isArray(state.design_system.component_families)) throw new Error("Template design_system.component_families must be an array");
if (!state.revision || state.revision.status !== "none") throw new Error("Template revision status must default to none");
if (!state.figma) throw new Error("Template figma schema is missing");
for (const key of ["target_url", "target_section", "created_section_id", "section_title_frame_id", "flow_title_frame_ids", "created_frame_ids"]) {
  if (!(key in state.figma)) throw new Error(`Template figma.${key} is missing`);
}
if (!Array.isArray(state.figma.flow_title_frame_ids)) throw new Error("Template figma.flow_title_frame_ids must be an array");
if (!Array.isArray(state.figma.created_frame_ids)) throw new Error("Template figma.created_frame_ids must be an array");
if (!state.blocked_input_request || state.blocked_input_request.status !== "none") throw new Error("Template blocked_input_request status must default to none");
console.log("Context intake, Figma, and revision schema OK");
NODE

test -f .codex/agents/revision-manager.toml
test -f .codex/skills/revision-request/SKILL.md
test -f .codex/skills/baseline-reference/SKILL.md
test -f .codex/skills/research-reference/SKILL.md
test -f .codex/skills/design-system-reference/SKILL.md
test -f .codex/design-systems/README.md
test -f .codex/design-systems/content-ecosystem-design/registry.md
test -f .codex/design-systems/content-ecosystem-design/component-library-index.md
test -f .codex/design-systems/content-ecosystem-design/component-selection-rules.md
test -f .codex/design-systems/content-ecosystem-design/recipes/button.md
test -f .codex/design-systems/content-ecosystem-design/recipes/form-controls.md
test -f .codex/design-systems/content-ecosystem-design/recipes/table.md
echo "Context intake and revision files OK"

if rg -n --hidden --glob '!.git' --glob '!scripts/verify-harness.sh' 'task-context|userflow-spec|scenario-quality-review|ui-surface-generation-spec|ui-generation-spec\.md|flow-to-surface-mapping|surface-assembly-spec|ai-interface|self-check' .; then
  echo "Found stale workflow terms." >&2
  exit 1
fi

if find . -name .DS_Store -print | rg .; then
  echo "Found .DS_Store files." >&2
  exit 1
fi

echo "Harness verification OK"
