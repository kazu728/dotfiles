.PHONY: build-mac
build-mac:
	@echo "Building for Mac"
	sudo darwin-rebuild switch --flake ./mac/.#aarch64

.PHONY: build-rpi
# example: make build-rpi USER=user
build-rpi: sync-nixconfig-to-rpi deploy-to-rpi	

.PHONY: sync-nixconfig-to-rpi
sync-nixconfig-to-rpi:
	rsync -avz --no-perms --no-owner --no-group --omit-dir-times -e "ssh" ./rpi/. $(USER)@rpi:/etc/nixos/

.PHONY: deploy-to-rpi
deploy-to-rpi:
	ssh $(USER)@rpi "cd /etc/nixos && sudo nixos-rebuild switch --flake .#rpi"
	
.PHONY: brew-dump
brew-dump:
	@echo "Dumping Brewfile"
	brew bundle dump --file=mac/Brewfile --force