{
  pkgs,
  herdr,
  ...
}:

{
  home.packages = [ herdr.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  xdg.configFile."herdr/config.toml".source = ../../config/herdr/config.toml;
}
