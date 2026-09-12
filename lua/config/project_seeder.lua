local M = {}

-- Map file types to their respective project root markers and template names
local language_configs = {
  cs = {
    markers = function(name, _)
      return name:match("%.sln$") ~= nil or name:match("%.csproj$") ~= nil or name == ".git"
    end,
    template_name = "csharp.editorconfig",
    lsp_service = "roslyn",
  },
}

function M.seed_config()
  local filetype = vim.bo.filetype
  local config = language_configs[filetype]

  -- Exit if this filetype doesn't have an automated template mapped
  if not config then
    return
  end

  -- Find the true project root folder
  local root_dir = vim.fs.root(0, config.markers)
  if not root_dir then
    return
  end

  local target_path = root_dir .. "/.editorconfig"
  local template_path = vim.fn.expand("~/.config/nvim/templates/" .. config.template_name)

  -- Don't overwrite if an .editorconfig already exists in the workspace root
  if vim.fn.filereadable(target_path) == 0 then
    if vim.fn.filereadable(template_path) == 1 then
      local success = vim.loop.fs_copyfile(template_path, target_path)

      if success then
        vim.notify("🚀 Generated project .editorconfig from " .. config.template_name, vim.log.levels.INFO)

        -- Automatically reload the language server if it is active
        if config.lsp_service then
          pcall(function()
            vim.cmd("LspRestart " .. config.lsp_service)
          end)
        end
      end
    end
  end
end

return M
