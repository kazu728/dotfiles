nix-install:
	curl -L https://nixos.org/nix/install | sh
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
	nix-channel --update

home-manager-install:
	nix-channel --update

	# @see https://github.com/nix-community/home-manager/issues/2564#issuecomment-994943471
	export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
	nix-shell '<home-manager>' -A install

nix-darwin-install:
	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer

home-manager-apply: 
	home-manager -f ~/ghq/github.com/kazu728/dotfiles/nixpkgs/home.nix switch

darwin-rebuild: 
	darwin-rebuild switch -I darwin-config=~/ghq/github.com/kazu728/dotfiles/nixpkgs/darwin-configuration.nix

.PHONY: nix-install home-manager-install home-manager-apply nix-darwin-install darwin-rebuild