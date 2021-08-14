#!/bin/bash

# brew
setup_brew(){
  echo Start install brew...
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew bundle install --file=./Brewfile
  echo Done
}

# zsh
setup_zsh(){
  echo Start setup zsh

  cd ~ && git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done

  echo Done
}

# anyenv
env_install(){
  envs=(nodenv)
  for env in ${envs[*]}
  do
    echo Install ${env}...
    anyenv install $env
    echo Installed ${env}
  done

  exec $SHELL - l
}

setup_anyenv(){
  echo Start setup anyenv

  ANY_ENV_ROOT="~/.anyenv" 
  anyenv install --init
  exec $SHELL

  mkdir -p $ANY_ENV_ROOT/plugins
  git clone https://github.com/znz/anyenv-update.git $ANY_ENV_ROOT/plugins/anyenv-update
  anyenv update

  env_install

  echo Done
}

# symbolic link
setup_symbolic_link(){
  echo Start setup symbolic link

  configs=(gitconfig/.gitconfig .vimrc .tmux.conf)

  for i in ${confis}
  do
    ln -sf ~/dotfiles/${i} ~/${i}
  done

  ln -sf ~/dotfiles/anyenv/nodenv/default-packages ~/.anyenv/envs/nodenv/default-packages
  ln -sf ~/dotfiles/anyenv/rbenv/default-gems ~/.anyenv/envs/rbenv/default-gems

  echo Done
}

setup_brew
setup_zsh
setup_anyenv
setup_symbolic_link