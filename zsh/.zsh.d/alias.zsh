alias c='clear'
alias lla='ll -a'
alias ..='cd ..'
alias ...='cd ../..'
alias rm='rm -i'

alias ls='exa'
alias cat='bat'
alias dust='du'
alias awk='gawk'

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
alias gbd='git branch --merged | grep -Ev "\*|development|staging|main|master|production" | xargs git branch -d'
alias gz='git-cz --disable-emoji'

alias dc='docker container'
alias fig='docker-compose'
alias rsyncr='rsync -re "ssh -i ~/.ssh/key" dest user@ip:source'
alias dbx64='docker build --platform linux/amd64'

alias ubuntu=' docker run -it --rm  --platform linux/amd64 ubuntu /bin/bash'
