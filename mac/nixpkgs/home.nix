{ lib, pkgs, ... }:

let
  username = "kazuki";
  homeDirectory = "/Users/${username}";
in
{
  home.username = username;
  home.homeDirectory = lib.mkForce homeDirectory;
  home.packages = with pkgs; [
    bottom
    bun
    checkov
    gh
    ghq
    helix
    mise
    nil
    podman
    procs
    rustup
  ];

  home.stateVersion = "25.05";
  home.file.".config/ghostty/config".source = ../ghostty/config;
  home.file.".config/helix/config.toml".source = ../helix/config.toml;
  home.file.".config/helix/themes/onedark_pro_night_flat.toml".source =
    ../helix/themes/onedark_pro_night_flat.toml;
  home.file.".claude/commands" = {
    source = ../claude/commands;
    recursive = true;
  };
  home.file.".gitignore".text = ''
    .DS_Store
    node_modules
    .envrc
    .direnv
  '';
  
  nix.gc = {
    automatic = true;
    frequency = "monthly";
    options = "--delete-older-than 7d";
  };

  programs = {
    bat.enable = true;
    eza.enable = true;
    home-manager.enable = true;

    git = {
      enable = true;
      delta.enable = true;
      userName = "Kazuki Matsuo";
      userEmail = "kazuki.matsuo.728@gmail.com";
      extraConfig = {
        core = {
          editor = "nvim";
          ignorecase = false;
          excludesfile = "~/.gitignore";
        };
        color.ui = true;
        diff.compactionHeuristic = true;
        init.defaultBranch = "master";
        merge.ff = false;
        pull.rebase = true;
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        branch = {
          sort = "-committerdate";
        };
        tag = {
          sort = "-version:refname";
          gpgsign = true;
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        fetch = {
          prune = true;
          prunetags = true;
        };
        help = {
          autocorrect = "immediate";
        };
        rebase = {
          autosquash = true;
          autostash = true;
          updateRefs = true;
        };
        url = { "https://github.com/".insteadOf = "git@github.com:"; };
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingKey = "${homeDirectory}/.ssh/id_github_rsa.pub";
      };
    };

    lazygit = {
      enable = true;
      settings = {
        git.paging = {
          colorArg = "always";
          pager = "delta --paging=never";
        };
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = builtins.readFile ../neovim/init.vim;
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      dotDir = ".config/zsh";
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
        cat = "bat";
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
        gbd = "git branch --merged | egrep 'feature|fix|chore' | xargs git branch -d";
        gz = "git-cz --disable-emoji";
        dc = "docker container";
        doco = "docker compose";
        nix-direnv = "echo 'use flake' >> .envrc && direnv all";
        "??" = "gh copilot suggest -t shell '$1'";
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
  };
}
