{ config, lib, pkgs, ... }:

{
  home.username = "kazuki";
  home.homeDirectory = "/Users/kazuki";
  home.packages = with pkgs; [
    asdf
    ghq
    nodejs-18_x
    procs
    rustup
    yarn
    pstree
  ];

  home.stateVersion = "22.05";

  programs = {
    bat.enable = true;
    exa.enable = true;
    home-manager.enable = true;

    git = {
      enable = true;
      aliases = {
        graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        grapha = "log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      };
      extraConfig = {
        color = {
          ui = "auto";
        };
        core = {
          editor = "nvim";
        };
        diff = {
          compactionHeuristic = true;
        };
        init = {
          defaultBranch = "master";
        };
        fetch = {
          prune = true;
        };
        merge = {
          ff = false;
        };
        pull = {
          rebase = true;
        };
        rebase = {
          autosquash = true;
          autostash = true;
        };
        url = {
          "https://github.com/".insteadOf = "git@github.com:";
        };
      };
      ignores = [
        ".DS_Store"
        ".direnv"
        "node_modules"
      ];
      userName = "Kazuki Matsuo";
      userEmail = "kazuki.matsuo.728@gmail.com";
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
      dotDir = "..config/zsh";
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        rm = "rm -i";
        ls = "exa";
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
        gcm = "git commit -m";
        gca = "git commit --amend";
        gbd = "git branch --merged | egrep 'feature|fix|chore' | xargs git branch -d";
        gz = "git-cz --disable-emoji";
        dc = "docker container";
        doco = "docker-compose";
        rsyncr = "rsync -re 'ssh -i ~/.ssh/key' dest user@ip:source";
        ubuntu = "docker run -it amd64/ubuntu bash";
      };

      initExtra = builtins.readFile ../zsh/.zshrc;
    };

    fzf = {
      enable = true;
      defaultOptions =
        [ "--layout=reverse" ];
    };

    starship = {
      enable = true;
      settings = {
        git_branch = {
          symbol = "🌱 ";
        };
        git_status = {
          disabled = true;
        };
        aws = {
          disabled = true;
        };
        gcloud = {
          disabled = true;
        };
        nodejs = {
          symbol = "Node ";
        };
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
