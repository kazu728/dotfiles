eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh)"

export PATH=$PATH:$HOME/.cargo/bin
export PATH=$HOME/.bun/bin:$PATH
export EDITOR=vim

# nixpkg壊れているのでグローバルに入れる `curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh``
export PATH=$HOME/.ghcup/bin:$PATH
export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock

export DISABLE_AUTOUPDATER=1
export MAX_THINKING_TOKENS=31999


ghq-fzf() {
  local repo=$(ghq list | fzf --preview "ghq list --full-path --exact {} | xargs ls -h --long --icons --classify --git --no-permissions --no-user --no-filesize --git-ignore --sort modified --reverse --tree --level 2")
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact $repo)
    BUFFER="cd ${repo}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

cdf() {
  local dir path d preview_cmd
  preview_cmd='eza -a --icons --classify --git --no-permissions --no-user --no-filesize --sort modified --reverse --tree --level 2 -- "{}" 2>/dev/null || ls -la "{}"'

  if command -v fd >/dev/null 2>&1; then
    dir=$(fd --type d --hidden --follow --exclude .git --strip-cwd-prefix | fzf --preview "$preview_cmd")
  elif command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    dir=$(git ls-files -co --exclude-standard -z | while IFS= read -r -d '' path; do
      d="${path#./}"
      d="${d%/*}"
      [[ "$d" == "$path" || -z "$d" || "$d" == "." ]] && continue
      while [[ -n "$d" && "$d" != "." ]]; do
        print -r -- "$d"
        [[ "$d" == */* ]] || break
        d="${d%/*}"
      done
    done | sort -u | fzf --preview "$preview_cmd")
  else
    dir=$(find . -mindepth 1 -type d -not -path '*/.git/*' -not -path './.git' -print | sed 's|^\./||' | fzf --preview "$preview_cmd")
  fi

  [[ -n "$dir" ]] && cd "$dir"
}

myip() {
  curl http://checkip.amazonaws.com/
}

'$'() {
    "$@"
}
