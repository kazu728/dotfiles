vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.keymap.set("n", "<leader>mp", function()
      local pane = vim.env.HERDR_PANE_ID
      if not pane then
        vim.notify("Not running inside herdr", vim.log.levels.WARN)
        return
      end

      local split = vim
        .system({ "herdr", "pane", "split", pane, "--direction", "right", "--no-focus" }, { text = true })
        :wait()
      if split.code ~= 0 then
        vim.notify(split.stderr, vim.log.levels.ERROR)
        return
      end

      -- Quitting mdpx closes the pane instead of leaving a bare shell behind
      local preview = vim.json.decode(split.stdout).result.pane.pane_id
      local command = ("mdpx %s; exit"):format(vim.fn.shellescape(vim.api.nvim_buf_get_name(args.buf)))
      vim.system({ "herdr", "pane", "run", preview, command })
    end, { buffer = args.buf, desc = "Preview markdown in a herdr pane" })
  end,
})
