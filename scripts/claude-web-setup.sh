#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
dest="$HOME/.claude/skills"

mkdir -p "$dest"
for skill in "$root"/agent-skills/*/*/; do
  [ -d "$skill" ] || continue
  ln -sfn "${skill%/}" "$dest/$(basename "$skill")"
done

echo "linked $(find "$dest" -maxdepth 1 -type l | wc -l | tr -d ' ') skills into $dest"
