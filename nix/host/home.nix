_:

{
  imports = [
    ./git-signing.nix
    ./ssh.nix
  ];

  xdg.configFile."ghostty/config".source = ../../config/ghostty/config;

  programs.reauthfi.enable = true;
}
