{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./git.nix
    ./neovim.nix
    ./yazi.nix
    ./herdr.nix
  ];

  home = {
    stateVersion = "26.05";

    packages = with pkgs; [
      delta
      jq
      procs
      ripgrep
    ];

    sessionVariables.EDITOR = "nvim";
  };

  xdg.enable = true;

  programs = {
    home-manager.enable = true;
    eza.enable = true;

    hunk = {
      enable = true;
      settings = {
        wrap_lines = true;
        sidebar = false;
        agent_notes = true;
      };
    };

    lazygit = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        customCommands = [
          {
            key = "O";
            context = "files";
            command = "hunk diff";
            output = "terminal";
            description = "hunk: review working tree";
          }
          {
            key = "I";
            context = "files";
            command = "hunk diff --staged";
            output = "terminal";
            description = "hunk: review staged changes";
          }
          {
            key = "O";
            context = "commits, subCommits, reflogCommits, commitFiles";
            command = "hunk show {{.SelectedCommit.Hash}}";
            output = "terminal";
            description = "hunk: review selected commit";
          }
        ];
        promptToReturnFromSubprocess = false;
        gui = {
          showCommandLog = false;
          sidePanelWidth = 0.2;
        };
        git.pagers = [
          {
            colorArg = "always";
            pager = "delta --paging=never --side-by-side";
          }
          {
            colorArg = "always";
            pager = "delta --paging=never";
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
  };
}
