#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage:
  scripts/init-task-from-prd.sh --file <prd-file> [--title "short english title"] [--figma-url <url>]
  scripts/init-task-from-prd.sh --text "<prd text>" [--title "short english title"] [--figma-url <url>]
  scripts/init-task-from-prd.sh --lark-url <docx-or-wiki-url> [--title "short english title"] [--figma-url <url>]

Options:
  --figma-url   Figma file URL where frames will be created (e.g. https://www.figma.com/file/XXX/Name)
  --yes         Skip the Lark document title confirmation prompt (for non-interactive use)

Creates projects/<auto-task-id>/ with the v4.1-MVP directory structure:
  current/
    prd.md, task-state.json, session-log.md, changelog.md
    stories/s1/
  logs/
  milestones/
USAGE
}

MODE=""
VALUE=""
TITLE=""
YES=""
FIGMA_URL=""

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
    --yes|-y)
      YES="yes"
      shift
      ;;
    --figma-url)
      FIGMA_URL="${2:-}"
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

python3 - "$MODE" "$VALUE" "$TITLE" "$YES" "$FIGMA_URL" <<'PY'
import json
import pathlib
import re
import shutil
import subprocess
import sys
import hashlib
from datetime import datetime, timezone

mode, value, provided_title, skip_confirm, figma_url = (
    sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
)
LARK_CLI_SETUP_URL = "https://bytedance.larkoffice.com/docx/PxZadXlz2o4mCmxjAvfc30H3nQg"


def extract_doc_title(text: str) -> str:
    """Extract the first meaningful heading or line from document text."""
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        # Strip markdown headings and XML title tags
        line = re.sub(r"^#{1,6}\s*", "", line)
        line = re.sub(r"^<title>(.*)</title>$", r"\1", line)
        line = re.sub(r"^(PRD|需求|标题|Title)\s*[:：]\s*", "", line, flags=re.I)
        line = line.strip()
        if line:
            return line[:120]
    return ""


def ask_confirm_tty(prompt: str) -> bool:
    """Read Y/n from the terminal directly, bypassing heredoc stdin.
    Returns True if user confirms (or if no TTY is available)."""
    try:
        with open("/dev/tty", "r") as tty:
            sys.stdout.write(prompt)
            sys.stdout.flush()
            answer = tty.readline().strip().lower()
        return answer in ("", "y", "yes")
    except OSError:
        # No TTY (piped / CI) — auto-confirm and note it
        sys.stdout.write(f"{prompt}[auto-confirmed: no TTY]\n")
        sys.stdout.flush()
        return True


def ask_figma_url_tty(provided: str) -> str:
    """Prompt for Figma file URL via TTY. Returns the URL string (may be empty)."""
    if provided:
        return provided
    try:
        with open("/dev/tty", "r") as tty:
            sys.stdout.write(
                "\n🎨 Figma 文件链接（frames 将在此文件中创建，留空可稍后通过 /setup 设置）: "
            )
            sys.stdout.flush()
            return tty.readline().strip()
    except OSError:
        # No TTY — skip silently
        return ""


def validate_figma_url(url: str) -> bool:
    return "figma.com" in url


# ── 1. Fetch PRD content ──────────────────────────────────────────────────────

if mode == "file":
    prd_path = pathlib.Path(value)
    if not prd_path.exists():
        raise SystemExit(f"PRD file not found: {value}")
    prd_text = prd_path.read_text(encoding="utf-8")
    source_reference = str(prd_path)

elif mode == "text":
    prd_text = value
    source_reference = "inline-text"

elif mode == "link":
    try:
        result = subprocess.run(
            [
                "lark-cli", "docs", "+fetch",
                "--api-version", "v2",
                "--doc", value,
                "--doc-format", "markdown",
                "--format", "json",
            ],
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError:
        raise SystemExit(
            "lark-cli not found. Install and configure Feishu CLI before using --lark-url.\n"
            f"Setup guide: {LARK_CLI_SETUP_URL}"
        )
    except subprocess.CalledProcessError as exc:
        details = (exc.stderr or exc.stdout or "").strip()
        raise SystemExit(
            "Failed to fetch Lark document.\n"
            f"Setup guide: {LARK_CLI_SETUP_URL}\n{details}"
        )

    try:
        payload = json.loads(result.stdout)
        document = payload["data"]["document"]
    except (KeyError, json.JSONDecodeError) as exc:
        raise SystemExit(f"Unexpected lark-cli response: {exc}")

    prd_text = (
        document.get("content") or document.get("markdown") or document.get("text") or ""
    )
    if not prd_text.strip():
        raise SystemExit("Fetched Lark document is empty.")
    source_reference = value

    # ── Title confirmation ────────────────────────────────────────────────────
    doc_title = extract_doc_title(prd_text)
    print(f"\n📄 飞书文档标题：「{doc_title}」")
    print(f"   {value}")

    if skip_confirm != "yes":
        confirmed = ask_confirm_tty("\n确认使用该文档初始化任务？(Y/n) ")
        if not confirmed:
            print("\n已取消。如需使用其他文档，请重新运行并提供正确的链接。")
            sys.exit(0)
    print()

else:
    raise SystemExit(f"Unsupported mode: {mode}")

# ── 1b. Collect Figma URL ─────────────────────────────────────────────────────

collected_figma_url = ask_figma_url_tty(figma_url)

# Validate if provided; one retry on bad format
if collected_figma_url and not validate_figma_url(collected_figma_url):
    try:
        with open("/dev/tty", "r") as tty:
            sys.stdout.write(
                "⚠️  链接格式不对（需包含 figma.com），请重新输入（留空跳过）: "
            )
            sys.stdout.flush()
            collected_figma_url = tty.readline().strip()
    except OSError:
        collected_figma_url = ""

    if collected_figma_url and not validate_figma_url(collected_figma_url):
        print("⚠️  Figma 链接无效，已跳过。请在任务初始化后通过 /setup 命令设置。")
        collected_figma_url = ""

# ── 2. Derive task_id ─────────────────────────────────────────────────────────

def first_meaningful_line(text: str) -> str:
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        line = re.sub(r"^#{1,6}\s*", "", line)
        line = re.sub(r"^(PRD|需求|标题|Title)\s*[:：]\s*", "", line, flags=re.I)
        if line:
            return line
    return "design-task"

def slugify(text: str) -> str:
    text = text.strip().lower()
    text = re.sub(r"['\"`]", "", text)
    ascii_text = re.sub(r"[^a-z0-9]+", "-", text).strip("-")
    return (ascii_text[:48].strip("-")) if ascii_text else "prd-design-task"

seed = provided_title.strip() or first_meaningful_line(prd_text)
base = slugify(seed)
digest = hashlib.sha1(prd_text.encode("utf-8")).hexdigest()[:8]
task_id = re.sub(r"-+", "-", f"{base}-{digest}").strip("-")

# ── 3. Create directory structure ─────────────────────────────────────────────

project_dir   = pathlib.Path("projects") / task_id
current_dir   = project_dir / "current"
stories_s1    = current_dir / "stories" / "s1"
logs_dir      = project_dir / "logs"
milestones_dir = project_dir / "milestones"

if (current_dir / "task-state.json").exists():
    raise SystemExit(f"Task already exists: {project_dir}")

for d in [stories_s1, logs_dir, milestones_dir]:
    d.mkdir(parents=True, exist_ok=True)

# ── 4. Write prd.md ───────────────────────────────────────────────────────────

if mode == "file":
    suffix = pathlib.Path(source_reference).suffix or ".md"
    prd_dest = current_dir / f"prd{suffix}"
    shutil.copyfile(source_reference, prd_dest)
    prd_ref = str(prd_dest)
else:
    prd_dest = current_dir / "prd.md"
    prd_dest.write_text(prd_text.strip() + "\n", encoding="utf-8")
    prd_ref = str(prd_dest)

# ── 5. Write task-state.json ──────────────────────────────────────────────────

MODE_TYPE = {"file": "file", "text": "text", "link": "lark_url"}

template_path = pathlib.Path("harness/templates/task-state.json")
state = json.loads(template_path.read_text(encoding="utf-8"))

state["task_id"]    = task_id
state["created_at"] = datetime.now(timezone.utc).isoformat(timespec="seconds")
state["prd_source"]["type"]  = MODE_TYPE[mode]
state["prd_source"]["value"] = prd_ref

if mode == "link":
    state["prd_source"]["original_url"] = source_reference

if collected_figma_url:
    state["figma"]["target_url"] = collected_figma_url

state_file = current_dir / "task-state.json"
state_file.write_text(json.dumps(state, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

# ── 6. Write session-log.md ───────────────────────────────────────────────────

(current_dir / "session-log.md").write_text(
    f"# Session Log — {task_id}\n\n"
    "| time | agent | status | duration | notes |\n"
    "|---|---|---|---|---|\n",
    encoding="utf-8",
)

# ── 7. Write changelog.md ─────────────────────────────────────────────────────

(current_dir / "changelog.md").write_text(
    f"# Changelog — {task_id}\n\n"
    "| adj-id | timestamp | story_id | path | description | cause_type |\n"
    "|---|---|---|---|---|---|\n",
    encoding="utf-8",
)

# ── 8. Print summary ──────────────────────────────────────────────────────────

figma_line = (
    f"    figma.target_url  = {collected_figma_url}"
    if collected_figma_url
    else "    figma.target_url  = (not set — run /setup to configure)"
)

print(f"""
✅  Task initialized: {task_id}

    {project_dir}/
    ├── current/
    │   ├── prd.md
    │   ├── task-state.json
    │   ├── session-log.md
    │   ├── changelog.md
    │   └── stories/
    │       └── s1/              ← prd-analyst may add more stories here
    ├── logs/
    └── milestones/

{figma_line}

Next step:
    Run prd-analyst on this task.
    It will read current/prd.md and write current/prd-analysis.json.

TASK_ID={task_id}
""")
PY
