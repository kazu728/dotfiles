{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    darwin.url = "github:LnL7/nix-darwin";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, utils }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    utils.lib.eachDefaultSystem (system:
      let 
        lib = nixpkgs.lib;
        homeConfig = import ./home.nix { inherit lib pkgs; };
        darwinConfig = import ./darwin.nix { inherit lib pkgs; };
      in
      {
        homeConfigurations = {
          kazuki = home-manager.lib.homeManagerConfiguration {
            configuration = homeConfig;
            system = system;
            pkgs = nixpkgs.legacyPackages.${system};
          };
        };
      };
      {
        darwinConfigurations = {
          kazuki = darwin.lib.darwinSystem {
            modules = [ darwinConfig ];
            system = system;
            pkgs = nixpkgs.legacyPackages.${system};
          };
        };
      }
    );
}