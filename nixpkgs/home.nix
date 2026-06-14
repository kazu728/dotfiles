{ lib, pkgs, ... }:

let
  username = "kazuki";
  homeDirectory = "/Users/${username}";
in
{
  imports = [
    ./modules/ghostty.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/yazi.nix
  ];

  home.username = username;
  home.homeDirectory = lib.mkForce homeDirectory;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    bun
    deadnix
    gh
    ghq
    go
    lima
    mise
    nix-output-monitor
    nixfmt
    procs
    ripgrep
    rustup
    statix
  ];

  home.sessionVariables = {
    BUN_INSTALL = "${homeDirectory}/.bun";
    DISABLE_AUTOUPDATER = "1";
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };

  home.sessionPath = [
    "${homeDirectory}/.local/bin"
    "${homeDirectory}/.bun/bin"
    "${homeDirectory}/.cargo/bin"
  ];

  xdg.enable = true;

  home.file.".local/bin/git-aicommit" = {
    source = ../scripts/git-aicommit;
    executable = true;
  };

  programs = {
    home-manager.enable = true;
    eza.enable = true;

    hunk = {
      enable = true;
      enableGitIntegration = false;
    };

    lazygit = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        gui = {
          showCommandLog = false;
          sidePanelWidth = 0.2;
        };
        git.pagers = [
          {
            colorArg = "always";
            pager = "hunk pager";
          }
        ];
      };
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
