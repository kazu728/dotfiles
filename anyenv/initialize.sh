#!/bin/sh

init(){
  ANY_ENV_ROOT="~/.anyenv" 
  anyenv install --init
  exec $SHELL

  mkdir -p $ANY_ENV_ROOT/plugins
  git clone https://github.com/znz/anyenv-update.git $ANY_ENV_ROOT/plugins/anyenv-update
}

env_install(){
  envs=(nodenv rbenv goenv)
  for env in ${envs[*]}
  do
    anyenv install env
  done

  exec $SHELL - l
}

node_install(){
  nodenv install 12.15.0
  nodenv global $_
}

ruby_install(){
  rbenv install 2.6.5
  rbenv global $_
}

go_install(){
  goenv install 1.13.10
  goenv global $_
  mkdir $HOME/go
}

init
env_install
node_install && ruby_install && go_install