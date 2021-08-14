alias c='clear'
alias lla='ll -a'
alias ..='cd ..'
alias ...='cd ../..'
alias rm='rm -i'

alias ls='exa'
alias cat='bat'
alias find='fd'
alias dust='du'

alias vsc='vi ~/.ssh/config'

alias vz='vim ~/.zshrc'
alias sz='source ~/.zshrc'
alias t='tmux'

alias ga='git add -A'
alias gs='git status'
alias gb='git branch'
alias co='git checkout'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gsu='git stash save -u'
alias gcm='git commit -m'
alias gca='git commit --amend'

alias dc='docker container'
alias fig='docker-compose'

alias ubuntu='docker run -it --rm ubuntu /bin/bash'