{ config, ... }:

let
  signingKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHxrSOVyERLr5n6WAxcHo8lKeiVR4ai2bqbC68lR/Vt8MEv2JKmvZQh6aoO9eSbs6m3vG3czdB1Dn6nQkErOcRA= github@secretive.mba.local";
in
{
  xdg.configFile."git/allowed_signers".text = "kazuki.matsuo.728@gmail.com ${signingKey}\n";

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
        editor = "nvim --clean";
        ignorecase = false;
      };
      diff.compactionHeuristic = true;
      fetch = {
        prune = true;
        prunetags = true;
      };
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
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
      user = {
        name = "Kazuki Matsuo";
        email = "kazuki.matsuo.728@gmail.com";
        signingKey = "key::${signingKey}";
      };
    };
  };
}
