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

  -- 2. Add the custom Mason registry so Mason can find the "roslyn" package
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.registries = opts.registries or { "github:mason-org/mason-registry" }
      table.insert(opts.registries, 1, "github:seblyng/mason-roslyn")
    end,
  },

  -- 3. Install and initialize the roslyn.nvim plugin
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      { "williamboman/mason.nvim" },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("roslyn").setup({
        args = {
          "--logLevel=Information",
          -- MODERN FIX: Uses the updated 0.12+ non-deprecated logging API
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
