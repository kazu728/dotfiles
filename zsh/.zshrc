eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh)"

export PATH=$PATH:$HOME/.cargo/bin
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
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
  local dir entry preview_cmd
  preview_cmd='eza -a --icons --classify --git --no-permissions --no-user --no-filesize --sort modified --reverse --tree --level 2 -- "{}" 2>/dev/null || ls -la "{}"'

  if command -v fd >/dev/null 2>&1; then
    dir=$(fd --type d --hidden --follow --exclude .git --strip-cwd-prefix --color=never 2>/dev/null |
      fzf --preview "$preview_cmd")
  else
    dir=$(find . -mindepth 1 -type d -not -path '*/.git/*' -not -path './.git' -print 2>/dev/null |
      while IFS= read -r entry; do
        print -r -- "${entry#./}"
      done | fzf --preview "$preview_cmd")
  fi

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
  local -a branches list positions
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

  if [[ -n "$bind" ]]; then
    target=$(printf '%s\n' "${list[@]}" | fzf --multi --prompt='delete!> ' --height 40% --reverse --sync \
      --bind "$bind" \
      --bind 'space:toggle,ctrl-space:toggle' \
      --preview 'git log --color=always --date=short --pretty=format:"%C(auto)%ad %h %d %s" -n 10 {}')
  else
    target=$(printf '%s\n' "${list[@]}" | fzf --multi --prompt='delete!> ' --height 40% --reverse --sync \
      --bind 'space:toggle,ctrl-space:toggle' \
      --preview 'git log --color=always --date=short --pretty=format:"%C(auto)%ad %h %d %s" -n 10 {}')
  fi
  [[ -z "$target" ]] && return 0
  while IFS= read -r line; do
    git branch -D "$line"
  done <<< "$target"
}

myip() {
  curl http://checkip.amazonaws.com/
}

'$'() {
    "$@"
}
