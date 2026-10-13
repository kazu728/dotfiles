_:

{
  imports = [
    ./git-signing.nix
    ./ssh.nix
  ];

  xdg.configFile."ghostty/config".source = ../../config/ghostty/config;
  xdg.configFile."karabiner".source = ../../config/karabiner;

  programs.reauthfi.enable = true;
}
