#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

sources=(AGENTS.md agents)

if [ -n "$(git status --porcelain -- "${sources[@]}")" ]; then
  echo "AGENTS.md or agents/ has uncommitted changes; commit and push them first" >&2
  exit 1
fi

# Pinning the last commit that touched the sources changes the script whenever they change,
# which is what makes Claude Code on the web rebuild its cached environment snapshot.
rev=$(git log -1 --format=%H -- "${sources[@]}")
if ! git merge-base --is-ancestor "$rev" origin/main; then
  echo "$rev is not on origin/main; push it first" >&2
  exit 1
fi

apm_version=$(apm --version | sed -nE 's/.* version ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
if [ -z "$apm_version" ]; then
  echo "could not read the APM version" >&2
  exit 1
fi

cat <<SETUP
#!/usr/bin/env bash
set -euo pipefail

work=\$(mktemp -d)
trap 'rm -rf "\$work"' EXIT

curl -fsSL https://github.com/microsoft/apm/releases/download/v${apm_version}/apm-linux-x86_64.tar.gz | tar -xz -C "\$work"
git init -q "\$work/dotfiles"
git -C "\$work/dotfiles" fetch -q --depth 1 https://github.com/kazu728/dotfiles ${rev}
git -C "\$work/dotfiles" checkout -q FETCH_HEAD

# APM 0.34.0 reports git as missing for every dependency when it runs from /.
cd "\$work"
"\$work/apm-linux-x86_64/apm" install --global "\$work/dotfiles/agents" --target claude
cp "\$work/dotfiles/AGENTS.md" "\$HOME/.claude/CLAUDE.md"
SETUP
