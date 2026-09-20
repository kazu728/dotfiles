{
  config,
  lib,
  pkgs,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/ghq/github.com/kazu728/dotfiles";
  apm = pkgs.callPackage ../packages/apm.nix { };
in
{
  home.activation.agentSkills = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run env PATH="${
      lib.makeBinPath [
        apm
        pkgs.git
        pkgs.gh
        pkgs.gnumake
      ]
    }:$PATH" ${pkgs.gnumake}/bin/make -C ${lib.escapeShellArg dotfilesDir} skills
  '';
}
