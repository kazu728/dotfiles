{ pkgs, ... }:

{
  home.packages = [ pkgs.ghq ];

  programs = {
    mise.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zsh.initContent = builtins.readFile ../../config/zsh/dev.zsh;

    neovim = {
      extraPackages = with pkgs; [
        clang-tools
        elmPackages.elm-language-server
        elixir-ls
        typescript-language-server
        nil
        ty
      ];

      initLua = builtins.readFile ../../config/neovim/lsp.lua;
    };
  };
}
