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

.PHONY: build-rpi
# example: make build-rpi USER=user
build-rpi: sync-nixconfig-to-rpi deploy-to-rpi	

.PHONY: sync-nixconfig-to-rpi
sync-nixconfig-to-rpi:
	rsync -avz --no-perms --no-owner --no-group --omit-dir-times --rsync-path="sudo rsync" -e "ssh" ./rpi/. $(USER)@rpi:/etc/nixos/

.PHONY: deploy-to-rpi
deploy-to-rpi:
	ssh $(USER)@rpi "cd /etc/nixos && NIX_STORE_LOG=trace sudo nixos-rebuild switch --flake .#rpi"

.PHONY: tailscale-rpi
tailscale-rpi:
	ssh $(USER)@rpi "sudo tailscale up -ssh"
	
.PHONY: brew-dump
brew-dump:
	@echo "Dumping Brewfile"
	brew bundle dump --file=mac/Brewfile --force
