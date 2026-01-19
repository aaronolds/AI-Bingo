#!/usr/bin/env bash
set -euo pipefail

# Creates GitHub issues from story markdown files under ./stories.
# Requires: GitHub CLI (gh) authenticated with repo access.
#
# Defaults to dry-run. Use --apply to actually create issues.
# Defaults to Epic 2–6 stories only. Use --all-epics to include Epic 0–1 as well.
#
# Examples:
#   ./scripts/create_github_issues_from_stories.sh --dry-run
#   ./scripts/create_github_issues_from_stories.sh --apply
#   ./scripts/create_github_issues_from_stories.sh --apply --repo aaronolds/AI-Bingo

repo=""
apply=false
include_placeholder=false
all_epics=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo="$2"
      shift 2
      ;;
    --apply)
      apply=true
      shift
      ;;
    --dry-run)
      apply=false
      shift
      ;;
    --include-placeholder)
      include_placeholder=true
      shift
      ;;
    --all-epics)
      all_epics=true
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage: create_github_issues_from_stories.sh [--apply|--dry-run] [--repo owner/name] [--all-epics] [--include-placeholder]

Creates GitHub issues from ./stories markdown story files.

Options:
  --apply               Actually create issues (default is dry-run).
  --dry-run             Print what would be created.
  --repo owner/name     Target repo (defaults to the current git remote).
  --all-epics           Include Epic 0–1 stories (default publishes Epic 2–6 only).
  --include-placeholder Include stories/epic-2-placeholder-services-and-web.md
EOF
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: GitHub CLI (gh) not found. Install it: https://cli.github.com/" >&2
  exit 1
fi

if [[ -n "$repo" ]]; then
  gh_repo_args=(--repo "$repo")
else
  gh_repo_args=()
fi

# Ensure we can talk to GitHub.
if ! gh auth status "${gh_repo_args[@]}" >/dev/null 2>&1; then
  echo "ERROR: gh is not authenticated for this repo. Run: gh auth login" >&2
  exit 1
fi

# Create/update labels for epics.
# Using --force keeps reruns safe.
create_label() {
  local name="$1";
  local color="$2";
  local desc="$3";

  if $apply; then
    gh label create "$name" --color "$color" --description "$desc" --force "${gh_repo_args[@]}" >/dev/null
  else
    echo "[dry-run] ensure label: $name"
  fi
}

create_label "story" "1D76DB" "Work item derived from a story markdown file"
create_label "epic-0" "6F42C1" "Repo foundation"
create_label "epic-1" "6F42C1" "Aspire setup"
create_label "epic-2" "6F42C1" "Domain and data"
create_label "epic-3" "6F42C1" "API"
create_label "epic-4" "6F42C1" "Real time"
create_label "epic-5" "6F42C1" "Frontend"
create_label "epic-6" "6F42C1" "Deployment"

# Stories to publish.
shopt -s nullglob
if $all_epics; then
  story_files=(stories/epic-*-story-*.md)
else
  story_files=(stories/epic-[2-6]-story-*.md)
fi
shopt -u nullglob

if $include_placeholder; then
  story_files+=(stories/epic-2-placeholder-services-and-web.md)
fi

if [[ ${#story_files[@]} -eq 0 ]]; then
  echo "No story files found under ./stories (expected stories/epic-*-story-*.md)" >&2
  exit 1
fi

created=0
skipped=0

for file in "${story_files[@]}"; do
  # Title is the first markdown heading line.
  title="$(head -n 1 "$file" | sed -E 's/^#\s+//')"

  if [[ -z "$title" ]]; then
    echo "Skipping $file (missing title)" >&2
    skipped=$((skipped+1))
    continue
  fi

  epic_label=""
  if [[ "$file" =~ stories/(epic-[0-9]+)-story- ]]; then
    epic_label="${BASH_REMATCH[1]}"
  fi

  # Skip if an issue with the exact same title already exists.
  existing_count="$(gh issue list "${gh_repo_args[@]}" --state all --search "$title" --json title --jq "[.[] | select(.title == \"$title\")] | length")"
  if [[ "$existing_count" != "0" ]]; then
    echo "[skip] already exists: $title"
    skipped=$((skipped+1))
    continue
  fi

  # Body: file content without the first title line.
  body_tmp="$(mktemp)"
  tail -n +2 "$file" > "$body_tmp"

  labels=("story")
  if [[ -n "$epic_label" ]]; then
    labels+=("$epic_label")
  fi

  if $apply; then
    gh issue create "${gh_repo_args[@]}" \
      --title "$title" \
      --body-file "$body_tmp" \
      $(printf -- '--label %q ' "${labels[@]}") \
      >/dev/null
    echo "[created] $title"
    created=$((created+1))
  else
    echo "[dry-run] would create: $title"
    echo "          labels: ${labels[*]}"
    created=$((created+1))
  fi

  rm -f "$body_tmp"
done

echo
if $apply; then
  echo "Done. Created: $created. Skipped: $skipped."
else
  echo "Dry run complete. Would create: $created. Skipped (already exists/missing title): $skipped."
  echo "Re-run with --apply to actually create issues."
fi
