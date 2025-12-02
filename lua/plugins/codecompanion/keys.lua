local mapping_key_prefix = vim.g.ai_prefix_key or "<leader>a"

local KEYS = {
  -- Recommended setup
  {
    mapping_key_prefix .. "a",
    function()
      vim.cmd("CodeCompanionChat Toggle")
      vim.cmd("startinsert")
    end,
    desc = "Code Companion - Toggle",
    mode = { "n", "v" },
  },

  {
    mapping_key_prefix .. "d",
    "<cmd>CodeCompanionChat Add<cr>",
    desc = "Code Companion - Add visually selected chat to the current chat buffer",
    mode = { "n", "v" },
  },

  {
    mapping_key_prefix .. "p",
    "<cmd>CodeCompanionActions<cr>",
    desc = "Code Companion - Prompt Actions",
    mode = { "n", "v" },
  },

  -- Custom prompts
  {
    mapping_key_prefix .. "m",
    "<cmd>CodeCompanion /commit<cr>",
    desc = "Code Companion - Git commit message",
    mode = { "n" },
  },
  {
    mapping_key_prefix .. "M",
    "<cmd>CodeCompanion /commit-push<cr>",
    desc = "Code Companion - Commit and push",
    mode = { "n" },
  },
}
return KEYS
