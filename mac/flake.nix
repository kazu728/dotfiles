{
  description = "Darwin system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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