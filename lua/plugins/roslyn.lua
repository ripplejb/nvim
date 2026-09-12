-- Use the settings below for .Net project configured to mimic JetBrains Rider.

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

  -- 3. Install and initialize the roslyn.nvim plugin with Rider-like parameters
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
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_filename()),
        },
        config = {
          capabilities = capabilities,
          settings = {
            -- Rider-like Full Solution Analysis: Proactively scans all files, not just open ones
            ["csharp|background_analysis"] = {
              dotnet_compiler_diagnostics_scope = "fullSolution",
              dotnet_analyzer_diagnostics_scope = "fullSolution",
            },
            -- Rider-like Rich Inlay Hints: Shows implicit types, parameter names, and metadata inline
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              csharp_enable_inlay_hints_from_metadata = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
            },
            -- Rider-like Code Lens: Displays references directly above methods/classes
            ["csharp|code_lens"] = {
              dotnet_enable_references_code_lens = true,
              dotnet_enable_tests_code_lens = true,
            },
            -- Enforce latest analyzer styles globally
            ["csharp|code_style"] = {
              dotnet_analyzer_diagnostics_level = "latest",
            },
          },
        },
      })
    end,
  },
}
