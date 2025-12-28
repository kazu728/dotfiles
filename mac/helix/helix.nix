{ pkgs, ... }:

{
  home.packages = with pkgs; [
    helix
  ];

  xdg.configFile."helix/config.toml".source = ../helix/config.toml;
  xdg.configFile."helix/themes/onedark_pro_night_flat.toml".source = ../helix/themes/onedark_pro_night_flat.toml;

  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --paging=never";
      };
    };
  };
}
