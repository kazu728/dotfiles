{
  description = "Host and VM configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hunk = {
      url = "github:modem-dev/hunk/v0.23.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    reauthfi = {
      url = "github:kazu728/reauthfi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr/v0.9.3";
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

      vmSystem = "aarch64-linux";
      vmPkgs = import nixpkgs { system = vmSystem; };
      vmUsers = map (machine: "kazuki@${machine}") [
        "private"
        "work"
      ];

      lintChecks = pkgs: {
        deadnix = pkgs.runCommandLocal "deadnix-check" { } ''
          ${pkgs.deadnix}/bin/deadnix --fail ${self}
          touch $out
        '';
        nixfmt = pkgs.runCommandLocal "nixfmt-check" { } ''
          find ${self} -name '*.nix' -print0 | xargs -0 ${pkgs.nixfmt}/bin/nixfmt --check
          touch $out
        '';
        statix = pkgs.runCommandLocal "statix-check" { } ''
          ${pkgs.statix}/bin/statix check ${self}
          touch $out
        '';
      };
    in
    {
      formatter = {
        ${system} = pkgs.nixfmt;
        ${vmSystem} = vmPkgs.nixfmt;
      };

      checks.${system} = lintChecks pkgs // {
        host = self.darwinConfigurations.host.system;
      };

      checks.${vmSystem} =
        lintChecks vmPkgs
        // nixpkgs.lib.genAttrs vmUsers (user: self.homeConfigurations.${user}.activationPackage);

      darwinConfigurations.host = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/host/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              sharedModules = [
                hunk.homeManagerModules.default
                reauthfi.homeManagerModules.default
              ];
              extraSpecialArgs = { inherit herdr; };
              users.kazuki.imports = [
                ./nix/shared/home.nix
                ./nix/host/home.nix
              ];
            };
          }
        ];
      };

      homeConfigurations = nixpkgs.lib.genAttrs vmUsers (
        _:
        home-manager.lib.homeManagerConfiguration {
          pkgs = vmPkgs;
          modules = [
            hunk.homeManagerModules.default
            ./nix/shared/home.nix
            ./nix/vm/home.nix
          ];
          extraSpecialArgs = { inherit herdr; };
        }
      );
    };
}
