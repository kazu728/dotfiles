cache_cleanup() {
  local mode="${1:-safe}"
  local targets=(
    "$HOME/.cache/uv"
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
