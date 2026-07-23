{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = "kazuki";
  homeDirectory = "/Users/${username}";
  hunkReviewSkill = "${config.programs.hunk.package}/skills/hunk-review";
in
{
  imports = [
    ./modules/ghostty.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/yazi.nix
    ./modules/herdr.nix
    ./modules/agent-skills.nix
  ];

  home = {
    inherit username;
    homeDirectory = lib.mkForce homeDirectory;
    stateVersion = "26.05";

    packages = with pkgs; [
      bun
      deadnix
      delta
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

    sessionVariables = {
      BUN_INSTALL = "${homeDirectory}/.bun";
      DISABLE_AUTOUPDATER = "1";
      EDITOR = "nvim";
      SSH_AUTH_SOCK = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
    };

    sessionPath = [
      "${homeDirectory}/.local/bin"
      "${homeDirectory}/.bun/bin"
      "${homeDirectory}/.cargo/bin"
    ];

    file = {
      ".local/bin/git-aicommit" = {
        source = ../scripts/git-aicommit;
        executable = true;
      };
      ".local/share/git-aicommit/subject-policy.md".source =
        ../agent-skills/personal/aicommit/subject-policy.md;

      "AGENTS.md".source = ../AGENTS.md;
      ".claude/CLAUDE.md".text = "@~/AGENTS.md\n";
      ".codex/AGENTS.md".source = ../AGENTS.md;

      ".claude/statusline.sh".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/ghq/github.com/kazu728/dotfiles/scripts/claude-statusline.sh";

      ".claude/skills/hunk-review".source = hunkReviewSkill;
      ".codex/skills/hunk-review".source = hunkReviewSkill;
    };
  };

  xdg.enable = true;

  programs = {
    home-manager.enable = true;
    eza.enable = true;

    hunk = {
      enable = true;
      settings.wrap_lines = true;
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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
