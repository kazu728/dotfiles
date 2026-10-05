BUN_GLOBAL_PACKAGES := @openai/codex opencode-ai elm @earendil-works/pi-coding-agent
APM_HOME := $(HOME)/.apm
APM_GENERATED := $(APM_HOME)/apm.yml $(APM_HOME)/apm.lock.yaml $(APM_HOME)/apm_modules
SKILL_DIRS := $(HOME)/.agents/skills $(HOME)/.claude/skills
NIX := /nix/var/nix/profiles/default/bin/nix

.PHONY: init
init:
	test -x /opt/homebrew/bin/brew || { echo "Install Homebrew first: https://brew.sh/"; exit 1; }
	test -x $(NIX) || curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh
	sudo $(NIX) --extra-experimental-features "nix-command flakes" run --inputs-from . darwin#darwin-rebuild -- switch --flake .#aarch64
	PATH="/etc/profiles/per-user/$$USER/bin:/run/current-system/sw/bin:$$PATH" $(MAKE) tools skills

.PHONY: build
build:
	@echo "Building for Mac"
	sudo darwin-rebuild switch --flake .#aarch64
	$(MAKE) skills

.PHONY: tools
tools:
	@echo "Installing bun global packages"
	bun install -g $(BUN_GLOBAL_PACKAGES)

.PHONY: check
check:
	@echo "Checking flake"
	nix flake check --print-build-logs

.PHONY: skills
skills:
	rm -rf $(SKILL_DIRS) $(APM_GENERATED)
	apm install --global "$(CURDIR)/agents" --target agent-skills,claude
