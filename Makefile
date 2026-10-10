BUN_GLOBAL_PACKAGES := @openai/codex opencode-ai elm @earendil-works/pi-coding-agent
APM_HOME := $(HOME)/.apm
APM_GENERATED := $(APM_HOME)/apm.yml $(APM_HOME)/apm.lock.yaml $(APM_HOME)/apm_modules
SKILL_DIRS := $(HOME)/.agents/skills $(HOME)/.claude/skills
NIX := /nix/var/nix/profiles/default/bin/nix

.PHONY: init
init:
	test -x /opt/homebrew/bin/brew || { echo "Install Homebrew first: https://brew.sh/"; exit 1; }
	test -x $(NIX) || curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh
	sudo $(NIX) --extra-experimental-features "nix-command flakes" run --inputs-from . darwin#darwin-rebuild -- switch --flake .#host

.PHONY: switch
switch:
ifeq ($(shell uname -s),Darwin)
	sudo darwin-rebuild switch --flake .#host
else
	nix --extra-experimental-features "nix-command flakes" run --inputs-from . home-manager -- switch --flake .
	$(MAKE) tools skills
endif

.PHONY: vm-create
vm-create:
	test -n "$(NAME)" || { echo "Usage: make vm-create NAME=<machine>"; exit 1; }
	orb create --isolated --isolate-network ubuntu:noble $(NAME)
	set -o pipefail; infocmp -x xterm-ghostty | orb -m $(NAME) tic -x -
	orb -m $(NAME) bash -c "$$(cat $(CURDIR)/scripts/vm-bootstrap.sh)" vm-bootstrap "$$(git branch --show-current)"

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
