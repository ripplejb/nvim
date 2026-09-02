-- Use the settings below for .Net project.

return {
  -- 1. Forcefully disable omnisharp to favor roslyn
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = { enabled = false },
      },
    },
  },

  -- 2. FIXED: Use the correct community Mason registry repository string
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.registries = opts.registries or { "github:mason-org/mason-registry" }
      -- Inserts the correct Crashdummyy registry at the front
      table.insert(opts.registries, 1, "github:Crashdummyy/mason-registry")
    end,
  },

  -- 3. Install and initialize the roslyn.nvim plugin
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      { "mason-org/mason.nvim" },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("roslyn").setup({
        args = {
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
        },
        config = {
          capabilities = capabilities,
          settings = {
            ["csharp|background_analysis"] = {
              dotnet_compiler_diagnostics_scope = "openFiles",
              dotnet_analyzer_diagnostics_scope = "openFiles",
            },
          },
        },
      })
    end,
  },
}
