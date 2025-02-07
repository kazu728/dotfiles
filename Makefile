.PHONY: build-mac
build-mac:
	@echo "Building for Mac"
	darwin-rebuild switch --flake ./mac/.#aarch64

.PHONY: build-rpi
# 実行時にUSERの環境変数が必要
build-rpi: sync-nixconfig-to-rpi deploy-to-rpi	

.PHONY: sync-nixconfig-to-rpi
sync-nixconfig-to-rpi:
	rsync -avz --no-perms --no-owner --no-group --omit-dir-times -e "ssh" ./rpi/nixpkgs/. $(USER)@rpi:/etc/nixos/

.PHONY: deploy-to-rpi
deploy-to-rpi:
	ssh $(USER)@rpi "sudo nixos-rebuild switch"
	
