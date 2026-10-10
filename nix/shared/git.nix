_:

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
      core = {
        editor = "nvim --clean";
        ignorecase = false;
      };
      diff.compactionHeuristic = true;
      fetch = {
        prune = true;
        prunetags = true;
      };
      help = {
        autocorrect = "immediate";
      };
      init.defaultBranch = "main";
      merge.ff = false;
      pager = {
        diff = "hunk pager";
        show = "hunk pager";
      };
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
      tag.sort = "-version:refname";
      user = {
        name = "Kazuki Matsuo";
        email = "kazuki.matsuo.728@gmail.com";
      };
    };
  };
}
