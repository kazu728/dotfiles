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
      (nvim-treesitter.withPlugins (
        p: with p; [
          c
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
      clang-tools
      elmPackages.elm-language-server
      elixir-ls
      nodejs
      typescript-language-server
      nil
      rust-analyzer
    ];

    initLua = builtins.readFile ../../config/neovim/init.lua;
  };

  xdg.configFile."nvim/lua/markdown_preview.lua".source = ../../config/neovim/markdown_preview.lua;
}
