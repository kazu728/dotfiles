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
