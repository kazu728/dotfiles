{ pkgs, mdpx, ... }:

{
  imports = [
    ./git-signing.nix
    ./ssh.nix
  ];

  home.packages = [ mdpx.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  xdg.configFile."ghostty/config".source = ../../config/ghostty/config;
  xdg.configFile."karabiner".source = ../../config/karabiner;

  programs.reauthfi.enable = true;
}
