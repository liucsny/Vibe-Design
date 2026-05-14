#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "--maintenance" ]]; then
  echo "Usage: scripts/init-task.sh --maintenance <task-id>" >&2
  echo "For normal PRD workflows, use scripts/init-task-from-prd.sh --file <prd-file> or --text \"<prd text>\"." >&2
  exit 1
fi

TASK_ID="${2:-}"

if [[ -z "$TASK_ID" ]]; then
  echo "Usage: scripts/init-task.sh --maintenance <task-id>" >&2
  echo "For normal PRD workflows, use scripts/init-task-from-prd.sh --file <prd-file> or --text \"<prd text>\"." >&2
  exit 1
fi

if [[ ! "$TASK_ID" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "task-id must use lowercase letters, numbers, and hyphens." >&2
  exit 1
fi

TASK_DIR="projects/${TASK_ID}/current"
PROJECT_DIR="projects/${TASK_ID}"
STATE_FILE="${TASK_DIR}/task-state.json"

if [[ -e "$STATE_FILE" ]]; then
  echo "Task already exists: ${STATE_FILE}" >&2
  exit 1
fi

mkdir -p "$TASK_DIR"
cp harness/templates/task-state.json "$STATE_FILE"
perl -pi -e "s/<task-id>/${TASK_ID}/g" "$STATE_FILE"
cp harness/templates/progress.md "${PROJECT_DIR}/progress.md"
cp harness/templates/session-handoff.md "${PROJECT_DIR}/session-handoff.md"
perl -pi -e "s/<task-id>/${TASK_ID}/g; s/<derived-title>/${TASK_ID}/g" "${PROJECT_DIR}/progress.md"
perl -pi -e "s/<task-id>/${TASK_ID}/g; s/<derived-title>/${TASK_ID}/g" "${PROJECT_DIR}/session-handoff.md"

echo "Created ${STATE_FILE}"
