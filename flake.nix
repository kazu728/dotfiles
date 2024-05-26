# darwin-rebuild switch --flake .#aarch64

{
  description = "Darwin system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:lnl7/nix-darwin";
  };

  outputs = { darwin, home-manager, ... }: {
    darwinConfigurations.aarch64 = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./nixpkgs/darwin-configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kazuki = import ./nixpkgs/home.nix;
        }
      ];
    };
  };
}