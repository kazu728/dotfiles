{
  description = "NixOS configuration for Raspberry Pi 4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Secrets management
    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        nixos-hardware.nixosModules.raspberry-pi-4

        # sops-nix.nixosModules.sops

        ./nixpkgs/hardware-configuration.nix
        ./nixpkgs/configuration.nix
        ];
    };
  };
}