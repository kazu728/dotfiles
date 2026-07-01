{
  description = "Darwin system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    reauthfi = {
      url = "github:kazu728/reauthfi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      darwin,
      herdr,
      home-manager,
      hunk,
      reauthfi,
      nixpkgs,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      checks.${system} = {
        darwin = self.darwinConfigurations.aarch64.system;
        deadnix = pkgs.runCommandLocal "deadnix-check" { } ''
          ${pkgs.deadnix}/bin/deadnix --fail ${self}
          touch $out
        '';
        nixfmt = pkgs.runCommandLocal "nixfmt-check" { } ''
          find ${self} -name '*.nix' -print0 | xargs -0 ${pkgs.nixfmt}/bin/nixfmt --check
          touch $out
        '';
        statix = pkgs.runCommandLocal "statix-check" { } ''
          cat > statix.toml <<'EOF'
          disabled = ["repeated_keys"]
          nix_version = "2.4"
          ignore = [".direnv"]
          EOF

          ${pkgs.statix}/bin/statix check --config statix.toml ${self}
          touch $out
        '';
      };

      darwinConfigurations.aarch64 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nixpkgs/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              hunk.homeManagerModules.default
              reauthfi.homeManagerModules.default
            ];
            home-manager.extraSpecialArgs = { inherit herdr; };
            home-manager.users.kazuki = import ./nixpkgs/home.nix;
          }
        ];
      };
    };
}
