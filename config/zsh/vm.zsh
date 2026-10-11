eval "$(mise activate zsh)"

cache_cleanup() {
  local mode="${1:-safe}"
  local targets=(
    "$HOME/.cache/uv"
    "$HOME/.bun/install/cache"
    "$HOME/.npm/_cacache"
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
      rm -rf "$HOME/.bun/install/cache"
      ;;
  esac

  echo "After:"
  df -h /
}

ghq-fzf() {
  local repo
  repo=$(ghq list | fzf)
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact "$repo")
    BUFFER="cd ${(q)repo}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

alias codex='codex --sandbox danger-full-access --ask-for-approval never -c '\''tui.status_line=["model","five-hour-limit","weekly-limit"]'\'''
alias claude='claude --permission-mode auto'

opencode() {
  local -a auto
  case "${1-}" in
    ""|-*|run) auto=(--auto) ;;
    *) [[ -d $1 ]] && auto=(--auto) ;;
  esac
  OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1 command opencode "$@" "${auto[@]}"
}
