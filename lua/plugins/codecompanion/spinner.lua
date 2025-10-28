local spinner_states = {
  completed = "󰗡 Completed",
  error = " Error",
  cancelled = "󰜺 Cancelled",
  handles = {},
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
return function()
  local ok, progress = pcall(require, "fidget.progress")
  if not ok then
    return
  end

  local group = vim.api.nvim_create_augroup("dotfiles.codecompanion.spinner", {})

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(args)
      local handle = progress.handle.create({
        title = "",
        message = "  Sending...",
        lsp_client = {
          name = format_adapter(args.data.adapter),
        },
      })
      spinner_states.handles[args.data.id] = handle
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(args)
      local handle = spinner_states.handles[args.data.id]
      spinner_states.handles[args.data.id] = nil
      if handle then
        if args.data.status == "success" then
          handle.message = spinner_states.completed
        elseif args.data.status == "error" then
          handle.message = spinner_states.error
        else
          handle.message = spinner_states.cancelled
        end
        handle:finish()
      end
    end,
  })
end
