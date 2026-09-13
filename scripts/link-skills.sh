#!/usr/bin/env bash
set -euo pipefail

# Supported local installer for the skills in this repository.
#
# Usage:
#   bash scripts/link-skills.sh
#   bash scripts/link-skills.sh --include-in-progress
#
# Links stable skills into the local skill directories used by each agent
# harness:
#   - ~/.claude/skills: Claude Code
#   - ~/.agents/skills: Codex and other Agent Skills-compatible harnesses
# Each entry is a symlink into this repo, so a `git pull` is all that's needed
# to keep installed skills up to date.

usage() {
  cat <<'EOF'
Usage: bash scripts/link-skills.sh [--include-in-progress]

Link the stable engineering and productivity skills into the user-level skill
directories for Claude Code and Codex.

Options:
  --include-in-progress  Also link beta skills from skills/in-progress.
  -h, --help             Show this help text.
EOF
}

include_in_progress=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --include-in-progress)
      include_in_progress=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

# Collect the selected skills once, then link them into every destination.
# Stable installation includes the promoted `engineering/` and `productivity/`
# buckets. `in-progress/` is opt-in. `deprecated/` and `misc/` are never linked.
names=()
srcs=()
skill_buckets=("engineering" "productivity")
if [ "$include_in_progress" = true ]; then
  skill_buckets+=("in-progress")
fi

for bucket in "${skill_buckets[@]}"; do
  while IFS= read -r -d '' skill_md; do
    src="$(dirname "$skill_md")"
    names+=("$(basename "$src")")
    srcs+=("$src")
  done < <(find "$REPO/skills/$bucket" -name SKILL.md -not -path '*/node_modules/*' -print0)
done

# Refuse to replace a user-owned directory or file with a symlink. Complete
# this preflight before creating any links so an install cannot stop halfway.
conflict_found=false
for DEST in "${DESTS[@]}"; do
  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"
    if [ -L "$target" ] && [ "$(readlink "$target")" != "$src" ]; then
      echo "error: $target is a symlink to another source." >&2
      conflict_found=true
    elif [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "error: $target exists and is not a symlink." >&2
      conflict_found=true
    fi
  done
done

if [ "$conflict_found" = true ]; then
  echo "Move the conflicting paths aside, then run the installer again." >&2
  exit 1
fi

for DEST in "${DESTS[@]}"; do
  # If $DEST is a symlink that resolves into this repo, we'd end up writing the
  # per-skill symlinks back into the repo's own skills/ tree. Detect and bail
  # out instead of polluting the working copy.
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$DEST\") and re-run; the script will recreate it as a real dir." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    ln -sfn "$src" "$target"
    echo "linked $name -> $src ($DEST)"
  done

  # Returning to the stable default removes only beta links created by this
  # repository. User-owned files and links to any other source remain intact.
  if [ "$include_in_progress" = false ]; then
    while IFS= read -r -d '' skill_md; do
      beta_src="$(dirname "$skill_md")"
      beta_target="$DEST/$(basename "$beta_src")"
      if [ -L "$beta_target" ] && [ "$(readlink "$beta_target")" = "$beta_src" ]; then
        unlink "$beta_target"
        echo "unlinked beta skill $beta_target"
      fi
    done < <(find "$REPO/skills/in-progress" -name SKILL.md -not -path '*/node_modules/*' -print0)
  fi
done

echo "installed ${#names[@]} skills"
if [ "$include_in_progress" = false ]; then
  echo "beta skills excluded; pass --include-in-progress to install them"
fi
