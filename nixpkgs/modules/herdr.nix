{
  lib,
  pkgs,
  herdr,
  ...
}:

let
  herdrPkg = herdr.packages.${pkgs.system}.default;
  integrations = [
    "claude"
    "codex"
  ];
in
{
  home.packages = [ herdrPkg ];

  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStringsSep "\n" (
      name: "run ${herdrPkg}/bin/herdr integration install ${name}"
    ) integrations
  );

  xdg.configFile."herdr/config.toml".source = ../../herdr/config.toml;
}
