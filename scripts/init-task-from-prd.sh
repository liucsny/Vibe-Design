#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage:
  scripts/init-task-from-prd.sh --file <prd-file> [--title "short english title"]
  scripts/init-task-from-prd.sh --text "<prd text>" [--title "short english title"]
  scripts/init-task-from-prd.sh --lark-url <docx-or-wiki-url> [--title "short english title"]

Creates projects/<auto-task-id>/current/task-state.json plus project progress and handoff files.
USAGE
}

MODE=""
VALUE=""
TITLE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file)
      MODE="file"
      VALUE="${2:-}"
      shift 2
      ;;
    --text)
      MODE="text"
      VALUE="${2:-}"
      shift 2
      ;;
    --lark-url|--url|--link)
      MODE="link"
      VALUE="${2:-}"
      shift 2
      ;;
    --title)
      TITLE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$MODE" || -z "$VALUE" ]]; then
  usage
  exit 1
fi

python3 - "$MODE" "$VALUE" "$TITLE" <<'PY'
import json
import pathlib
import re
import shutil
import subprocess
import sys

mode, value, provided_title = sys.argv[1], sys.argv[2], sys.argv[3]
LARK_CLI_SETUP_URL = "https://bytedance.larkoffice.com/docx/PxZadXlz2o4mCmxjAvfc30H3nQg"

if mode == "file":
    prd_path = pathlib.Path(value)
    if not prd_path.exists():
        raise SystemExit(f"PRD file not found: {value}")
    prd_text = prd_path.read_text(encoding="utf-8")
    source_reference = str(prd_path)
elif mode == "text":
    prd_text = value
    source_reference = "inline prompt"
elif mode == "link":
    try:
        result = subprocess.run(
            [
                "lark-cli",
                "docs",
                "+fetch",
                "--api-version",
                "v2",
                "--doc",
                value,
                "--doc-format",
                "markdown",
                "--format",
                "json",
            ],
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError:
        raise SystemExit(
            "lark-cli was not found. Install and configure Feishu CLI before using --lark-url.\n"
            f"Setup guide: {LARK_CLI_SETUP_URL}"
        )
    except subprocess.CalledProcessError as exc:
        details = (exc.stderr or exc.stdout or "").strip()
        raise SystemExit(
            "Failed to fetch Feishu/Lark PRD with lark-cli docs +fetch. "
            "Check CLI config, OAuth permissions, and document access.\n"
            f"Setup guide: {LARK_CLI_SETUP_URL}\n"
            f"{details}"
        )

    try:
        payload = json.loads(result.stdout)
        document = payload["data"]["document"]
    except (KeyError, json.JSONDecodeError) as exc:
        raise SystemExit(f"Unexpected lark-cli response while fetching PRD: {exc}")

    prd_text = (
        document.get("content")
        or document.get("markdown")
        or document.get("text")
        or ""
    )
    if not prd_text.strip():
        raise SystemExit("Fetched Feishu/Lark document is empty.")
    source_reference = value
else:
    raise SystemExit(f"Unsupported mode: {mode}")

def first_meaningful_line(text: str) -> str:
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        line = re.sub(r"^#{1,6}\s*", "", line)
        line = re.sub(r"^(PRD|需求|标题|Title)\s*[:：]\s*", "", line, flags=re.I)
        if line:
            return line
    return "design task"

def slugify(text: str) -> str:
    text = text.strip().lower()
    text = re.sub(r"['\"`]", "", text)
    ascii_text = re.sub(r"[^a-z0-9]+", "-", text).strip("-")
    if ascii_text:
        return ascii_text[:48].strip("-")

    # Deterministic pinyin-like transliteration is not available in stdlib.
    # For CJK PRDs, keep a readable generic prefix and add a stable hash below.
    return "prd-design-task"

seed = provided_title.strip() or first_meaningful_line(prd_text)
base = slugify(seed)

import hashlib
digest = hashlib.sha1(prd_text.encode("utf-8")).hexdigest()[:8]
task_id = f"{base}-{digest}"
task_id = re.sub(r"-+", "-", task_id).strip("-")

project_dir = pathlib.Path("projects") / task_id
task_dir = project_dir / "current"
state_file = task_dir / "task-state.json"
if state_file.exists():
    raise SystemExit(f"Task already exists: {state_file}")

task_dir.mkdir(parents=True, exist_ok=False)

template_path = pathlib.Path("harness/templates/task-state.json")
state = json.loads(template_path.read_text(encoding="utf-8").replace("<task-id>", task_id))
state["source_prd"]["type"] = mode
state["source_prd"]["reference"] = source_reference
state["source_prd"]["derived_title"] = seed
if mode == "link":
    state["source_prd"]["original_url"] = source_reference

state_file.write_text(json.dumps(state, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

if mode in ("text", "link"):
    (task_dir / "prd.md").write_text(prd_text.strip() + "\n", encoding="utf-8")
    state["source_prd"]["reference"] = str(task_dir / "prd.md")
    state_file.write_text(json.dumps(state, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
elif mode == "file":
    suffix = pathlib.Path(source_reference).suffix or ".md"
    copied_prd = task_dir / f"prd{suffix}"
    shutil.copyfile(source_reference, copied_prd)
    state["source_prd"]["reference"] = str(copied_prd)
    state_file.write_text(json.dumps(state, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

progress_template = pathlib.Path("harness/templates/progress.md").read_text(encoding="utf-8")
progress = progress_template.replace("<task-id>", task_id).replace("<derived-title>", seed)
(project_dir / "progress.md").write_text(progress, encoding="utf-8")

handoff_template = pathlib.Path("harness/templates/session-handoff.md").read_text(encoding="utf-8")
handoff = handoff_template.replace("<task-id>", task_id).replace("<derived-title>", seed)
(project_dir / "session-handoff.md").write_text(handoff, encoding="utf-8")

print(task_id)
print(state_file)
PY
