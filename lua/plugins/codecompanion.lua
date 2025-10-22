local CODECOMPANION_DEPENDANCIES = require("plugins.code-companion.dependencies")
local OPTS = require("plugins.code-companion.opts")
local KEYS = require("plugins.code-companion.keys")

return {
  "olimorris/codecompanion.nvim",
  dependencies = CODECOMPANION_DEPENDANCIES,
  opts = OPTS,
  keys = KEYS,
  config = function(_, opts)
    require("plugins.code-companion.spinner")
    local spinner = {
      completed = "󰗡 Completed",
      error = " Error",
      cancelled = "󰜺 Cancelled",
    }

    ---Format the adapter name and model for display with the spinner
    ---@param adapter CodeCompanion.Adapter
    ---@return string
    local function format_adapter(adapter)
      local parts = {}
      table.insert(parts, adapter.formatted_name)
      if adapter.model and adapter.model ~= "" then
        table.insert(parts, "(" .. adapter.model .. ")")
      end
      return table.concat(parts, " ")
    end

    ---Setup the spinner for CodeCompanion
    ---@return nil
    local function codecompanion_spinner()
      local ok, progress = pcall(require, "fidget.progress")
      if not ok then
        return
      end

      spinner.handles = {}

      local group = vim.api.nvim_create_augroup("dotfiles.codecompanion.spinner", {})

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(args)
          local handle = progress.handle.create({
            title = "",
            message = "  Sending...",
            lsp_client = {
              name = format_adapter(args.data.adapter),
            },
          })
          spinner.handles[args.data.id] = handle
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(args)
          local handle = spinner.handles[args.data.id]
          spinner.handles[args.data.id] = nil
          if handle then
            if args.data.status == "success" then
              handle.message = spinner.completed
            elseif args.data.status == "error" then
              handle.message = spinner.error
            else
              handle.message = spinner.cancelled
            end
            handle:finish()
          end
        end,
      })
    end
    codecompanion_spinner()

    -- Setup the entire opts table
    require("codecompanion").setup(opts)
  end,
}
