{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      fzf-lua
      nvim-lspconfig
    ];

    extraPackages = with pkgs; [
      typescript-language-server
      lua-language-server
      nil
      rust-analyzer
      gopls
    ];

    extraLuaConfig = builtins.readFile ../../neovim/init.lua;
  };
}
