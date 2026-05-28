{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      blink-cmp
      copilot-vim
      fzf-lua
      nvim-lspconfig
      (nvim-treesitter.withPlugins (p: with p; [
        markdown
        markdown-inline
        nix
        rust
        typescript
      ]))
      onedark-nvim
    ];

    extraPackages = with pkgs; [
      nodejs
      typescript-language-server
      nil
      rust-analyzer
    ];

    extraLuaConfig = builtins.readFile ../../neovim/init.lua;
  };
}
