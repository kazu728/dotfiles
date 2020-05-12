#!/bin/sh

ANY_ENV_ROOT="~/.anyenv" 

anyenv install --init
exec $SHELL

mkdir -p $ANY_ENV_ROOT/plugins
git clone https://github.com/znz/anyenv-update.git $ANY_ENV_ROOT/plugins/anyenv-update

# node
anyenv install nodenv
nodenv install 12.15.0
nodenv global $_

#ruby
anyenv install rbenv
rbenv install 2.6.5
rbenv global $_


