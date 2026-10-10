if [[ $HERDR_ENV == 1 && $TERM == xterm-256color ]]; then
  export TERM=xterm-ghostty
fi

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
  git branch -D -- "${(@f)target}"
}

'$'() {
    "$@"
}
