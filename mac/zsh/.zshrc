[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"

export PATH=$PATH:$HOME/.cargo/bin

# nixpkg壊れているのでグローバルに入れる `curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh``
export PATH=$HOME/.ghcup/bin:$PATH

ghq-fzf() {
  local repo=$(ghq list | fzf --preview "ghq list --full-path --exact {} | xargs exa -h --long --icons --classify --git --no-permissions --no-user --no-filesize --git-ignore --sort modified --reverse --tree --level 2")
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact $repo)
    BUFFER="cd ${repo}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

ip() {
  curl http://checkip.amazonaws.com/
}

[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
