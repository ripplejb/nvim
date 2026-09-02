-- If you are using google's agy cli.

return {
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Enable silent background file reloading
      vim.o.autoread = true

      -- Force a deep file-check whenever you toggle panes or stop typing
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("AgyDiskSync", { clear = true }),
        callback = function()
          if vim.fn.mode() ~= "c" and vim.fn.bufexists(0) == 1 then
            vim.cmd("checktime")
          end
        end,
      })
    end,
  },
}
