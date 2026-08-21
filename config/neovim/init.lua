vim.o.swapfile = false
vim.o.clipboard = "unnamed"
vim.o.laststatus = 0
vim.o.ruler = false
vim.o.updatetime = 1000
vim.o.complete = "o,.,w,b"
vim.o.completeopt = "menu,menuone,popup,noselect,fuzzy"

vim.g.mapleader = " "

vim.keymap.set({ "n", "i" }, "<C-j>", "<Esc>")

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

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

require("onedark").setup({
  colors = { bg0 = "#161719" },
})
require("onedark").load()

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      diagnostics = { experimental = { enable = true } },
    },
  },
})

vim.lsp.enable({ "ts_ls", "nil_ls", "rust_analyzer", "elmls", "elixirls", "clangd" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf)
    end
    if client and client:supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
      vim.api.nvim_clear_autocmds({ group = group, buffer = args.buf })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "grr", function()
      require("fzf-lua").lsp_references()
    end, opts)
  end,
})
