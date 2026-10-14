{
  lib,
  pkgs,
  herdr,
  ...
}:

let
  herdrPkg = herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;
  integrations = [
    "claude"
    "codex"
    "pi"
  ];
in
{
  home.packages = [ herdrPkg ];

  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.concatMapStringsSep "\n" (
      name:
      "run ${herdrPkg}/bin/herdr integration install ${name} || warnEcho 'herdr: skipped the ${name} integration'"
    ) integrations
  );

  xdg.configFile."herdr/config.toml".source = ../../config/herdr/config.toml;
}
