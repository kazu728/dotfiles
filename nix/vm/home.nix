{
  config,
  lib,
  pkgs,
  ...
}:

{
  home = {
    username = "kazuki";
    homeDirectory = "/home/kazuki";

    packages = with pkgs; [
      deadnix
      elmPackages.elm
      ghq
      go
      mise
      nix-output-monitor
      nixfmt
      rustup
      statix
    ];

    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  programs = {
    gh.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zsh.initContent = builtins.readFile ../../config/zsh/vm.zsh;

    neovim = {
      extraPackages = with pkgs; [
        clang-tools
        elmPackages.elm-language-server
        elixir-ls
        nodejs
        typescript-language-server
        nil
        rust-analyzer
        ty
      ];

      # Appended so that <leader> expands to the mapleader set in init.lua.
      initLua = lib.mkAfter (builtins.readFile ../../config/neovim/vm.lua);
    };
  };
}
