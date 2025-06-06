local mapping_key_prefix = vim.g.ai_prefix_key or "<leader>a"

local KEYS = {
  -- Recommended setup
  {
    mapping_key_prefix .. "p",
    "<cmd>CodeCompanionActions<cr>",
    desc = "Code Companion - Prompt Actions",
  },
  {
    mapping_key_prefix .. "a",
    function()
      vim.cmd("CodeCompanionChat Toggle")
      vim.cmd("startinsert")
    end,
    desc = "Code Companion - Toggle",
    mode = { "n", "v" },
  },
  -- Some common usages with visual mode
  {
    mapping_key_prefix .. "e",
    "<cmd>CodeCompanion /explain<cr>",
    desc = "Code Companion - Explain code",
    mode = "v",
  },
  {
    mapping_key_prefix .. "f",
    "<cmd>CodeCompanion /fix<cr>",
    desc = "Code Companion - Fix code",
    mode = "v",
  },
  {
    mapping_key_prefix .. "l",
    "<cmd>CodeCompanion /lsp<cr>",
    desc = "Code Companion - Explain LSP diagnostic",
    mode = { "n", "v" },
  },
  {
    mapping_key_prefix .. "t",
    "<cmd>CodeCompanion /tests<cr>",
    desc = "Code Companion - Generate unit test",
    mode = "v",
  },
  {
    mapping_key_prefix .. "m",
    "<cmd>CodeCompanion /commit<cr>",
    desc = "Code Companion - Git commit message",
  },
  -- Custom prompts
  {
    mapping_key_prefix .. "M",
    "<cmd>CodeCompanion /staged-commit<cr>",
    desc = "Code Companion - Git commit message (staged)",
  },
  {
    mapping_key_prefix .. "d",
    "<cmd>CodeCompanion /inline-doc<cr>",
    desc = "Code Companion - Inline document code",
    mode = "v",
  },
  { mapping_key_prefix .. "D", "<cmd>CodeCompanion /doc<cr>", desc = "Code Companion - Document code", mode = "v" },
  {
    mapping_key_prefix .. "r",
    "<cmd>CodeCompanion /refactor<cr>",
    desc = "Code Companion - Refactor code",
    mode = "v",
  },
  {
    mapping_key_prefix .. "R",
    "<cmd>CodeCompanion /review<cr>",
    desc = "Code Companion - Review code",
    mode = "v",
  },
  {
    mapping_key_prefix .. "n",
    "<cmd>CodeCompanion /naming<cr>",
    desc = "Code Companion - Better naming",
    mode = "v",
  },
  -- Quick chat
  {
    mapping_key_prefix .. "q",
    function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        vim.cmd("CodeCompanion " .. input)
      end
    end,
    desc = "Code Companion - Quick chat",
  },
}
return KEYS
