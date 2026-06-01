vim.opt.swapfile = false
vim.opt.clipboard = "unnamed"
vim.opt.termguicolors = true
vim.opt.laststatus = 0
vim.opt.ruler = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "i" }, "<C-j>", "<Esc>")

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, { command = "checktime" })
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, { command = "silent! wall" })

require("fzf-lua").setup({
  grep = {
    hidden = true,
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob '!**/.git/**' -e",
  },
})
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<cr>", { desc = "Resume" })
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document symbols" })
vim.keymap.set("n", "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })

vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float(nil, { scope = "line" })
end, { desc = "Line diagnostics" })

vim.keymap.set("n", "<leader>gg", function()
  vim.cmd("tabnew | terminal lazygit")
  vim.cmd("startinsert")
end, { desc = "Lazygit" })

vim.keymap.set("n", "<leader>gd", function()
  vim.cmd("tabnew | terminal hunk diff --watch")
  vim.cmd("startinsert")
end, { desc = "Hunk diff" })

require("blink.cmp").setup({
  keymap = { preset = "enter" },
})

require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
})

require("onedark").setup({
  style = "dark",
  colors = { bg0 = "#161719" },
})
require("onedark").load()

vim.lsp.enable({ "ts_ls", "nil_ls", "rust_analyzer", "elmls", "elixirls" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", function()
      require("fzf-lua").lsp_references()
    end, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})
