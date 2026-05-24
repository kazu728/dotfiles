{ config, ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "node_modules"
      ".envrc"
      ".direnv"
    ];
    settings = {
      branch = {
        sort = "-committerdate";
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
      url = {
        "https://github.com/".insteadOf = "git@github.com:";
      };
      user = {
        name = "Kazuki Matsuo";
        email = "kazuki.matsuo.728@gmail.com";
        signingKey = "${config.home.homeDirectory}/.ssh/id_github_rsa.pub";
      };
    };
  };
}
