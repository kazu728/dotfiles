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
    ./modules/agent-skills.nix
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
    jq
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

  home.file."AGENTS.md".source = ../AGENTS.md;
  home.file.".claude/CLAUDE.md".text = "@~/AGENTS.md\n";

  programs = {
    home-manager.enable = true;
    eza.enable = true;

    hunk = {
      enable = true;
      enableGitIntegration = false;
    };

    reauthfi.enable = true;

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
        format = "$directory$git_branch$git_state$git_status\n$character";
        git_branch.symbol = "🌱 ";
        git_branch.format = "[$symbol$branch]($style) ";
        git_status.format = "([\\[$conflicted\\]]($style) )";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
