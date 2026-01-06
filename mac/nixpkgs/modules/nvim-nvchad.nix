{ pkgs, ... }:

let
  nvchadStarter = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "starter";
    # Pin to a commit on main for reproducibility.
    rev = "e3572e1f5e1c297212c3deeb17b7863139ce663e";
    sha256 = "sha256-xdLr6tlU9uA+wu0pqha2br0fdVm+1MjgjbB5awz9ICU=";
  };
  nvchadPatched = pkgs.runCommand "nvchad-starter-patched" {} ''
    cp -r ${nvchadStarter} $out
    chmod -R u+w $out
    mkdir -p $out/vscode
    cp ${../../neovim/init.vim} $out/vscode/init.vim
    cat > $out/lua/chadrc.lua <<'EOF'
    -- This file needs to have same structure as nvconfig.lua
    -- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

    ---@type ChadrcConfig
    local M = {}

    M.base46 = {
      theme = "onedark",
      transparency = false,
      -- Match Ghostty "Atom" background (#161719).
      hl_override = {
        Normal = { bg = "#161719" },
        NormalNC = { bg = "#161719" },
        NormalFloat = { bg = "#161719" },
        FloatBorder = { bg = "#161719" },
        Pmenu = { bg = "#161719" },
        NvimTreeNormal = { bg = "#161719" },
        NvimTreeNormalNC = { bg = "#161719" },
        NvimTreeNormalFloat = { bg = "#161719" },
        NvimTreeEndOfBuffer = { bg = "#161719" },
        NvimTreeWinSeparator = { bg = "#161719" },
      },
    }

    M.ui = {
      statusline = {
        enabled = false,
      },
      tabufline = {
        enabled = false,
      },
    }

    return M
    EOF
    cat > $out/init.lua <<'EOF'
    if vim.g.vscode then
      local vscode_init = vim.fn.stdpath "config" .. "/vscode/init.vim"
      if vim.fn.filereadable(vscode_init) == 1 then
        vim.cmd("source " .. vscode_init)
      end
      return
    end

    vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
    vim.g.mapleader = " "

    -- bootstrap lazy and all plugins
    local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

    if not vim.uv.fs_stat(lazypath) then
      local repo = "https://github.com/folke/lazy.nvim.git"
      vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
    end

    vim.opt.rtp:prepend(lazypath)

    local lazy_config = require "configs.lazy"

    -- load plugins
    require("lazy").setup({
      {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
      },

      { import = "plugins" },
    }, lazy_config)

    local function load_base46_cache()
      local defaults = vim.g.base46_cache .. "defaults"
      local statusline = vim.g.base46_cache .. "statusline"

      if not (vim.uv.fs_stat(defaults) and vim.uv.fs_stat(statusline)) then
        local ok, base46 = pcall(require, "base46")
        if ok and base46.load_all_highlights then
          pcall(base46.load_all_highlights)
        end
      end

      if vim.uv.fs_stat(defaults) then
        pcall(dofile, defaults)
      end
      if vim.uv.fs_stat(statusline) then
        pcall(dofile, statusline)
      end
    end

    -- load theme
    load_base46_cache()

    require "options"
    require "autocmds"

    -- Load NvChad default mappings, then custom overrides.
    require "nvchad.mappings"

    vim.schedule(function()
      require "mappings"
    end)
    EOF
    cat > $out/lua/options.lua <<'EOF'
    require "nvchad.options"

    -- remove extra UI lines to maximize vertical space
    vim.o.laststatus = 0
    vim.o.showtabline = 0
    vim.o.winbar = ""
    EOF
    cat > $out/lua/mappings.lua <<'EOF'
    -- Custom mappings
    vim.keymap.set("i", "<C-j>", "<Esc>", { desc = "Exit insert mode" })
    vim.keymap.set("v", "<C-j>", "<Esc>", { desc = "Exit visual mode" })
    EOF
    mkdir -p $out/lua/plugins
    cat > $out/lua/plugins/nvim-tree.lua <<'EOF'
    return {
      {
        "nvim-tree/nvim-tree.lua",
        opts = {
          actions = {
            open_file = {
              window_picker = {
                enable = false,
              },
            },
          },
        },
      },
    }
    EOF
    cat > $out/lua/plugins/copilot.lua <<'EOF'
    return {
      {
        "github/copilot.vim",
        cmd = "Copilot",
        event = "InsertEnter",
      },
    }
    EOF
    cat > $out/lua/plugins/sidekick.lua <<'EOF'
    return {
      {
        "folke/sidekick.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
          {
            "<leader>aa",
            function()
              require("sidekick.cli").toggle()
            end,
            desc = "Sidekick Toggle CLI",
          },
          {
            "<leader>as",
            function()
              require("sidekick.cli").select()
            end,
            desc = "Sidekick Select CLI",
          },
          {
            "<leader>ad",
            function()
              require("sidekick.cli").close()
            end,
            desc = "Sidekick Detach CLI",
          },
          {
            "<leader>ap",
            function()
              require("sidekick.cli").prompt()
            end,
            mode = { "n", "x" },
            desc = "Sidekick Select Prompt",
          },
        },
      },
    }
    EOF
    cat > $out/lua/configs/lazy.lua <<'EOF'
    return {
      defaults = { lazy = true },
      install = { colorscheme = { "nvchad" } },
      -- Write lockfile to a writable location (config dir is read-only under Nix).
      lockfile = vim.fn.stdpath "data" .. "/lazy/lazy-lock.json",

      ui = {
        icons = {
          ft = "",
          lazy = "󰂠 ",
          loaded = "",
          not_loaded = "",
        },
      },

      performance = {
        rtp = {
          disabled_plugins = {
            "2html_plugin",
            "tohtml",
            "getscript",
            "getscriptPlugin",
            "gzip",
            "logipat",
            "netrw",
            "netrwPlugin",
            "netrwSettings",
            "netrwFileHandlers",
            "matchit",
            "tar",
            "tarPlugin",
            "rrhelper",
            "spellfile_plugin",
            "vimball",
            "vimballPlugin",
            "zip",
            "zipPlugin",
            "tutor",
            "rplugin",
            "syntax",
            "synmenu",
            "optwin",
            "compiler",
            "bugreport",
            "ftplugin",
          },
        },
      },
    }
    EOF
  '';
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  xdg.configFile."nvim".source = nvchadPatched;
}
