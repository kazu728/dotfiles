nix_install(){
  curl -L https://nixos.org/nix/install | sh
  nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
  nix-channel --update
}

add_homemanager(){
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update

  export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
  @see https://github.com/nix-community/home-manager/issues/2564#issuecomment-994943471

  nix-shell '<home-manager>' -A instal
}

add_nix_darwin(){
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
}


nix_install
add_homemanager
add_nix_darwin

home-manager -f ~/dotfiles/home.nix switch
darwin-rebuild switch -I darwin-config=~/dotfiles/configuration.nix