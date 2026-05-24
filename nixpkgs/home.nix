{ lib, pkgs, ... }:

let
  username = "kazuki";
  homeDirectory = "/Users/${username}";
in
{
  imports = [
    ./modules/helix.nix
    ./modules/ghostty.nix
    ./modules/zsh.nix
    ./modules/git.nix
  ];

  home.username = username;
  home.homeDirectory = lib.mkForce homeDirectory;
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    bun
    gh
    ghq
    go
    mise
    deadnix
    nil
    nix-output-monitor
    nixfmt-rfc-style
    procs
    ripgrep
    rustup
    statix
  ];

  home.sessionVariables = {
    BUN_INSTALL = "${homeDirectory}/.bun";
    DISABLE_AUTOUPDATER = "1";
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
  };

  home.sessionPath = [
    "${homeDirectory}/.local/bin"
    "${homeDirectory}/.bun/bin"
    "${homeDirectory}/.cargo/bin"
  ];

  xdg.enable = true;
  xdg.configFile."nvim".source = ../neovim;

  home.file.".local/bin/git-aicommit" = {
    source = ../scripts/git-aicommit;
    executable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 7d";
  };

  programs = {
    home-manager.enable = true;
    eza.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    fzf = {
      enable = true;
      defaultOptions = [ "--layout=reverse" ];
    };

    starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_state\n$character";
        git_branch.symbol = "🌱 ";
        git_branch.format = "[$symbol$branch]($style) ";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
