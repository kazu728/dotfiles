eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh)"

cache_cleanup() {
  local mode="${1:-safe}"
  local targets=(
    "$HOME/.cache/uv"
    "$HOME/.bun/install/cache"
    "$HOME/.npm/_cacache"
    "$HOME/Library/Caches"
  )

  if [[ "$mode" != "safe" && "$mode" != "full" ]]; then
    echo "Usage: cache_cleanup [safe|full]"
    return 1
  fi

  echo "Before:"
  du -sh "${targets[@]}" 2>/dev/null

  case "$mode" in
    safe)
      uv cache prune
      npm cache verify
      ;;
    full)
      read -q "REPLY?Delete caches now? [y/N] "
      echo
      if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        return 1
      fi
      uv cache clean
      npm cache clean --force
      rm -rf "$HOME/.bun/install/cache" "$HOME/Library/Caches/"*
      ;;
  esac

  echo "After:"
  df -h /
}

ghq-fzf() {
  local repo preview_cmd
  preview_cmd='repo=$(ghq list --full-path --exact {}) && { eza -a --icons --classify --git --no-permissions --no-user --no-filesize --git-ignore --sort modified --reverse --tree --level 2 -- "$repo" 2>/dev/null || ls -la "$repo"; }'
  repo=$(ghq list | fzf --preview "$preview_cmd")
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact "$repo")
    BUFFER="cd ${repo}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

cdf() {
  local dir entry preview_cmd
  preview_cmd='eza -a --icons --classify --git --no-permissions --no-user --no-filesize --sort modified --reverse --tree --level 2 -- "{}" 2>/dev/null || ls -la "{}"'

  dir=$(find . -mindepth 1 -type d -not -path '*/.git/*' -not -path './.git' -print 2>/dev/null |
    while IFS= read -r entry; do
      print -r -- "${entry#./}"
    done | fzf --preview "$preview_cmd")

  [[ -n "$dir" ]] && cd -- "$dir"
}

_git_fzf_guard() {
  command -v fzf >/dev/null 2>&1 || return 1
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1
}

gbs() {
  _git_fzf_guard || return 1
  local branch
  branch=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads |
    fzf --prompt='switch> ' --height 40% --reverse \
      --preview 'git log --oneline --decorate -n 20 --color=always {}')
  [[ -n "$branch" ]] && git switch "$branch"
}

gbd() {
  _git_fzf_guard || return 1
  local current target bind action pos branch
  local -a branches list positions fzf_opts
  local -A merged_set
  current=$(git branch --show-current)

  while IFS= read -r branch; do
    [[ -z "$branch" || "$branch" == "$current" ]] && continue
    branches+=("$branch")
  done < <(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads)

  while IFS= read -r branch; do
    [[ -z "$branch" || "$branch" == "$current" ]] && continue
    merged_set[$branch]=1
  done < <(git for-each-ref --merged=HEAD --format='%(refname:short)' refs/heads)

  if (( ${#branches[@]} == 0 )); then
    return 0
  fi

  list=("${branches[@]}")
  local i=1
  for branch in "${branches[@]}"; do
    [[ -n ${merged_set[$branch]} ]] && positions+=("$i")
    ((i++))
  done

  if (( ${#positions[@]} )); then
    for pos in "${positions[@]}"; do
      action+="pos(${pos})+select+"
    done
    bind="start:${action%+}+first"
  fi

  fzf_opts=(
    --multi
    --prompt='delete!> '
    --height 40%
    --reverse
    --sync
    --bind 'space:toggle,ctrl-space:toggle'
    --preview 'git log --color=always --date=short --pretty=format:"%C(auto)%ad %h %d %s" -n 10 {}'
  )
  if [[ -n "$bind" ]]; then
    fzf_opts+=(--bind "$bind")
  fi
  target=$(printf '%s\n' "${list[@]}" | fzf "${fzf_opts[@]}")

  [[ -z "$target" ]] && return 0
  while IFS= read -r line; do
    git branch -D "$line"
  done <<< "$target"
}

'$'() {
    "$@"
}

alias codex='codex -s workspace-write -a on-request'
alias claude='claude --permission-mode auto'
