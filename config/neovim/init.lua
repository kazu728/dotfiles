vim.o.swapfile = false
vim.o.clipboard = "unnamed"
vim.o.laststatus = 0
vim.o.ruler = false
vim.o.updatetime = 1000
vim.o.complete = "o,.,w,b"
vim.o.completeopt = "menu,menuone,popup,noselect,fuzzy"

vim.g.mapleader = " "

vim.keymap.set({ "n", "i" }, "<C-j>", "<Esc>")

vim.keymap.set("n", "<leader>gp", "<cmd>!git push<cr>")

vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 0 then
    return "<CR>"
  end
  return vim.fn.complete_info().selected ~= -1 and "<C-y>" or "<C-n><C-y>"
end, { expr = true, desc = "Accept completion / newline" })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, { command = "checktime" })
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "CursorHold", "CursorHoldI" }, {
  nested = true,
  command = "silent! wall",
})

-- Autocomplete on keystroke, but not on bare insert-enter
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.o.autocomplete = false
  end,
})
vim.api.nvim_create_autocmd("InsertCharPre", {
  callback = function()
    if vim.v.char == ";" then
      vim.o.autocomplete = false
    elseif not vim.o.autocomplete then
      vim.o.autocomplete = true
    end
  end,
})

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

vim.diagnostic.config({ signs = false, virtual_lines = { current_line = true } })

require("markdown_preview")

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

require("onedark").setup({
  colors = { bg0 = "#161719" },
})
require("onedark").load()
