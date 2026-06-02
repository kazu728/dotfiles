{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      copilot-vim
      fzf-lua
      nvim-lspconfig
      (nvim-treesitter.withPlugins (
        p: with p; [
          elm
          elixir
          nix
          rust
          typescript
        ]
      ))
      onedark-nvim
    ];

    extraPackages = with pkgs; [
      elmPackages.elm-language-server
      elixir-ls
      nodejs
      typescript-language-server
      nil
      rust-analyzer
    ];

    initLua = builtins.readFile ../../neovim/init.lua;
  };
}
