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
