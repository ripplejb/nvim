return {
  {
    "ripplejb/str-manipulator",
    config = function()
      require("str-man").setup({
        mappings = {
          ["<leader>sm"] = { "<cmd>StrMan<cr>", "String Manipulator" },
        },
      })
    end,
  },
}
