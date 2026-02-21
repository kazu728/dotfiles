{ lib, pkgs, ... }:

let
  username = "kazuki";
  homeDirectory = "/Users/${username}";
in
{
  imports = [
    ./modules/nvim-nvchad.nix
  ];
  home.username = username;
  home.homeDirectory = lib.mkForce homeDirectory;
  home.packages = with pkgs; [
    bun
    gh
    ghq
    mise
    nil
    procs
    ripgrep
    rustup
  ];

  home.stateVersion = "25.05";
  xdg.enable = true;
  xdg.configFile."ghostty/config".source = ../ghostty/config;

  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 7d";
  };

  programs = {
    eza.enable = true;
    home-manager.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    git = {
      enable = true;
      ignores = [ ".DS_Store" "node_modules" ".envrc" ".direnv" ];
      settings = {
        branch = {
          sort = "-committerdate";
        };
        color.ui = true;
        commit.gpgsign = true;
        core = {
          editor = "nvim --clean";
          ignorecase = false;
        };
        diff.compactionHeuristic = true;
        fetch = {
          prune = true;
          prunetags = true;
        };
        gpg.format = "ssh";
        help = {
          autocorrect = "immediate";
        };
        init.defaultBranch = "master";
        merge.ff = false;
        pull.rebase = true;
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        rebase = {
          autosquash = true;
          autostash = true;
          updateRefs = true;
        };
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        tag = {
          sort = "-version:refname";
          gpgsign = true;
        };
        url = { "https://github.com/".insteadOf = "git@github.com:"; };
        user = {
          name = "Kazuki Matsuo";
          email = "kazuki.matsuo.728@gmail.com";
          signingKey = "${homeDirectory}/.ssh/id_github_rsa.pub";
        };
      };
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      dotDir = "${homeDirectory}/.config/zsh";
      autosuggestion = {
          enable = true;
          strategy = [ "history" "completion" ];
          highlight = "fg=#666666";
        };
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      shellAliases = {
        rm = "rm -i";
        ls = "eza";
        ll = "ls -a";
        lla = "ls -la";
        ps = "procs";
        dust = "du";
        grep = "grep --color";
        ga = "git add -A";
        gs = "git status";
        gb = "git branch";
        co = "git checkout";
        gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        gsu = "git stash save -u";
        gco = "git commit";
        gca = "git commit --amend";
        gz = "git-cz --disable-emoji";
        dc = "docker container";
        doco = "docker compose";
        nix-direnv = "echo 'use flake' >> .envrc && direnv all";
      };

      initContent = builtins.readFile ../zsh/.zshrc;
    };

    fzf = {
      enable = true;
      defaultOptions = [ "--layout=reverse" ];
    };

    starship = {
      enable = true;
      settings = {
        git_branch.symbol = "🌱 ";
        git_status.disabled = true;
        aws.disabled = true;
        elixir.disabled = true;
        gcloud.disabled = true;
        nodejs.disabled = true;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    lazygit = {
      enable = true;
      settings = {
        gui.showCommandLog = false;
        gui.showBottomLine = false;
        gui.showPanelJumps = false;
        gui.showListFooter = false;
        gui.sidePanelWidth = 0.2;
        gui.expandFocusedSidePanel = true;
        git.paging = {
          colorArg = "always";
          pager = "delta --paging=never";
        };
      };
    };
  };
}
