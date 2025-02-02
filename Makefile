.PHONY: build-mac
build-mac:
	@echo "Building for Mac"
	darwin-rebuild switch --flake ./mac/.#aarch64
	

.PHONY: build-rpi
build-rpi:
	@echo "Building for Raspberry Pi"
	nixos-rebuild switch
	
