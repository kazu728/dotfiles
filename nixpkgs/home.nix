{ lib, pkgs, ... }:

let
  username = "kazuki";
  homeDirectory = "/Users/${username}";
in
{
  imports = [
    ../helix/helix.nix
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
  xdg.configFile."nvim".source = ../neovim;

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
        alias = {
          aicommit = ''!f() {
            if ! command -v codex >/dev/null 2>&1; then
              echo "codex not found in PATH" >&2
              exit 1
            fi

            if git diff --cached --quiet; then
              echo "No staged changes. Run git add first." >&2
              exit 1
            fi

            repo_root=$(git rev-parse --show-toplevel) || exit 1
            recent_subjects=$(git log --no-merges -n 20 --pretty=format:'%s' 2>/dev/null || true)
            tmpfile=$(mktemp) || exit 1
            trap 'rm -f "$tmpfile"' EXIT HUP INT TERM

            prompt=$(cat <<EOF
Inspect the staged git diff using git diff --cached.

Recent commit subjects from this repository:
$recent_subjects

Infer the dominant commit subject style from those examples.
When the style is clear, match it closely:
- use the same language
- preserve common prefixes such as feat:, fix:, chore:, docs:, refactor:
- keep similar tone, casing, punctuation, and length

If the examples are mixed or no clear style is present, return exactly one English Git commit subject line in imperative mood.
Summarize what changed and why.

Return exactly one commit subject line only.
Do not output quotes, markdown, bullets, code fences, or explanations.
EOF
            )

            codex exec -C "$repo_root" --sandbox read-only --ephemeral \
              -c 'model_reasoning_effort="medium"' -o "$tmpfile" \
              "$prompt" \
              >/dev/null || exit 1

            msg=$(tr -d '\r' < "$tmpfile")
            if [ -z "$msg" ]; then
              echo "Codex returned an empty commit message." >&2
              exit 1
            fi

            git commit -m "$msg" "$@"
          }; f'';
        };
        color.ui = true;
        commit.gpgsign = true;
        core = {
          editor = "nvim";
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

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
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
        format = "$directory$git_branch\n$character";
        git_branch.symbol = "🌱 ";
        git_branch.format = "[$symbol$branch]($style) ";
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
        git.pagers = [{
          colorArg = "always";
          pager = "delta --paging=never";
        }];
      };
    };
  };
}
