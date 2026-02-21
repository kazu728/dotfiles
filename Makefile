.PHONY: init
init:
	@if command -v nix >/dev/null 2>&1; then \
		echo "Nix is already installed"; \
	else \
		echo "Installing Nix..."; \
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate; \
	fi
	@if command -v darwin-rebuild >/dev/null 2>&1; then \
		echo "nix-darwin is already installed, running build..."; \
		$(MAKE) build; \
	else \
		echo "Setting up nix-darwin for the first time..."; \
		nix run nix-darwin -- switch --flake .#aarch64; \
	fi

.PHONY: build
build:
	@echo "Building for Mac"
	sudo darwin-rebuild switch --flake .#aarch64

.PHONY: brew-dump
brew-dump:
	@echo "Dumping Brewfile"
	brew bundle dump --file=Brewfile --force
