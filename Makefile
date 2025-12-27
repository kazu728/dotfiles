.PHONY: init
init:
	@if command -v nix >/dev/null 2>&1; then \
		echo "Nix is already installed"; \
	else \
		echo "Installing Nix..."; \
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate; \
	fi
	@if command -v darwin-rebuild >/dev/null 2>&1; then \
		echo "nix-darwin is already installed, running build-mac..."; \
		$(MAKE) build-mac; \
	else \
		echo "Setting up nix-darwin for the first time..."; \
		nix run nix-darwin -- switch --flake ./mac/.#aarch64; \
	fi

.PHONY: build-mac
build-mac:
	@echo "Building for Mac"
	sudo darwin-rebuild switch --flake ./mac/.#aarch64

N150_HOST ?= n150
N150_STAGE_DIR ?= /tmp/nixos-sync
.PHONY: build-n150
build-n150:
	ssh $(N150_HOST) "rm -rf $(N150_STAGE_DIR) && mkdir -p $(N150_STAGE_DIR)"
	rsync -avz --no-perms --no-owner --no-group --omit-dir-times -e "ssh" ./n150/. $(N150_HOST):$(N150_STAGE_DIR)/
	ssh -t $(N150_HOST) "sudo rsync -av --no-perms --no-owner --no-group --omit-dir-times $(N150_STAGE_DIR)/ /etc/nixos/ && cd /etc/nixos && sudo nixos-rebuild switch"

.PHONY: brew-dump
brew-dump:
	@echo "Dumping Brewfile"
	brew bundle dump --file=mac/Brewfile --force
