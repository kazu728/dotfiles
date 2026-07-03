{ config, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
      highlight = "fg=#666666";
    };
    syntaxHighlighting.enable = true;

    shellAliases = {
      rm = "rm -i";
      ll = "eza -a";
      lla = "eza -la";
      grep = "grep --color";
      ga = "git add -A";
      gs = "git status";
      gb = "git branch";
      co = "git checkout";
      gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      gsu = "git stash save -u";
      gco = "git commit";
      gca = "git commit --amend";
      dc = "docker container";
      doco = "docker compose";
    };

    initContent = builtins.readFile ../../zsh/.zshrc;
  };
}
