APM_HOME := $(HOME)/.apm
APM_GENERATED := $(APM_HOME)/apm.yml $(APM_HOME)/apm.lock.yaml $(APM_HOME)/apm_modules
SKILL_DIRS := $(HOME)/.agents/skills $(HOME)/.claude/skills
NIX := /nix/var/nix/profiles/default/bin/nix

.PHONY: init
init:
	test -x $(NIX) || curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh
	sudo $(NIX) --extra-experimental-features "nix-command flakes" run --inputs-from . darwin#darwin-rebuild -- switch --flake .#host
	PATH=/etc/profiles/per-user/$(USER)/bin:$$PATH $(MAKE) agents skills

.PHONY: switch
switch:
ifeq ($(shell uname -s),Darwin)
	sudo darwin-rebuild switch --flake .#host
else
	nix --extra-experimental-features "nix-command flakes" run --inputs-from . home-manager -- switch --flake .
endif
	$(MAKE) agents skills

.PHONY: vm-create
vm-create:
	test -n "$(NAME)" || { echo "Usage: make vm-create NAME=<machine>"; exit 1; }
	orb create --isolated --isolate-network ubuntu:noble $(NAME)
	set -o pipefail; infocmp -x xterm-ghostty | orb -m $(NAME) tic -x -
	orb -m $(NAME) bash -c "$$(cat $(CURDIR)/scripts/vm-bootstrap.sh)" vm-bootstrap "$$(git branch --show-current)"

.PHONY: agents
agents: export PATH := $(HOME)/.local/bin:$(HOME)/.opencode/bin:$(PATH)
agents:
	test -x $(HOME)/.local/bin/claude || curl -fsSL https://claude.ai/install.sh | bash
	test -x $(HOME)/.local/bin/codex || curl -fsSL https://chatgpt.com/codex/install.sh | sh
	test -x $(HOME)/.opencode/bin/opencode || curl -fsSL https://opencode.ai/install | bash
	test -x $(HOME)/.local/bin/pi || curl -fsSL https://pi.dev/install.sh | sh

.PHONY: check
check:
	@echo "Checking flake"
	nix flake check --print-build-logs

.PHONY: skills
skills:
	rm -rf $(SKILL_DIRS) $(APM_GENERATED)
	apm install --global "$(CURDIR)/agents" --target agent-skills,claude
