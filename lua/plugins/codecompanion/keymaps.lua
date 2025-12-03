local ai_prefix = vim.g.ai_prefix_key or "<leader>a"

local KEYS = {
  {
    ai_prefix .. "p",
    "<cmd>CodeCompanionActions<cr>",
    mode = { "n", "v" },
    desc = "Code Companion - Prompt Actions",
  },
  {
    ai_prefix .. "a",
    "<cmd>CodeCompanionChat Toggle<cr>",
    mode = { "n", "v" },
    desc = "Code Companion Toggle",
  },
  {
    ai_prefix .. "A",
    function()
      -- Exit visual mode first to set the '< and '> marks
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)

      -- Get the visual selection context
      local context = require("codecompanion.utils.context").get(vim.api.nvim_get_current_buf(), { range = 2 })
      local content = table.concat(context.lines, "\n")

      local cc = require("codecompanion")
      local chat = cc.last_chat()

      if not chat then
        -- Create new chat without visual context insertion
        -- This works around a bug where Add duplicates visual selection when creating a new chat
        chat = cc.chat({ context = { is_visual = false } })
        if not chat then
          return vim.notify("Could not create chat buffer", vim.log.levels.WARN)
        end
      end

      -- Add the code with the proper "Here is some code from..." format
      chat:add_buf_message({
        role = require("codecompanion.config").constants.USER_ROLE,
        content = "Here is some code from "
          .. context.filename
          .. ":\n\n```"
          .. context.filetype
          .. "\n"
          .. content
          .. "\n```\n",
      })

      -- Open the chat buffer and focus it
      chat.ui:open()
      if chat.ui.winnr and vim.api.nvim_win_is_valid(chat.ui.winnr) then
        vim.api.nvim_set_current_win(chat.ui.winnr)
      end
    end,
    mode = { "v" },
    desc = "Code Companion Add to Chat",
  },
  {
    ai_prefix .. "m",
    "<cmd>CodeCompanion /commit<cr>",
    mode = { "n" },
    desc = "Code Companion - Git commit message",
  },
  {
    ai_prefix .. "M",
    "<cmd>CodeCompanion /commit-push<cr>",
    mode = { "n" },
    desc = "Code Companion - Commit and push",
  },
}

return KEYS
