-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add shortcut for VVNote command
local wk = require("which-key")
vim.keymap.set("n", "<leader>vv", ":VVNote<CR>", { noremap = true, silent = true, desc = "Create Virgin Voyages note" })
wk.add({
  { "<leader>v", group = "Virgin Voyages", icon = "" },
  { "<leader>vv", ":VVNote<CR>", desc = "Create Virgin Voyages note", mode = "n" },
})

-- CodeCompanion keymaps with WhichKey descriptions
wk.add({
  { "<leader>a", group = "AI/CodeCompanion", icon = "" },
  { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Actions", mode = { "n", "v" } },
  { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat", mode = { "n", "v" } },
  { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to Chat", mode = "v" },
  { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", desc = "Explain Code", mode = "v" },
  { "<leader>af", "<cmd>CodeCompanion /fix<cr>", desc = "Fix Code", mode = "v" },
  { "<leader>ao", "<cmd>CodeCompanion /optimize<cr>", desc = "Optimize Code", mode = "v" },
  { "<leader>ar", "<cmd>CodeCompanion /refactor<cr>", desc = "Refactor Code", mode = "v" },
  { "<leader>at", "<cmd>CodeCompanion /tests<cr>", desc = "Generate Tests", mode = "v" },
  { "<leader>aD", "<cmd>CodeCompanion /document<cr>", desc = "Document Code", mode = "v" },
})
