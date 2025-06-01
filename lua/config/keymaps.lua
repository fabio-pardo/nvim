-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add shortcut for VVNote command
local wk = require("which-key")
wk.add({
  { "<leader>v", group = "Virgin Voyages", icon = "🚢" },
  { "<leader>vv", ":VVNote<CR>", desc = "Create Virgin Voyages note", mode = "n" },

  { "<leader>a", group = "AI Code Companion", icon = "🤖", mode = { "n", "v" } },

  { "<leader>m", group = "Marks", icon = "📍" },
  { "<leader>mm", desc = "List marks", mode = "n" },
  { "<leader>md", desc = "Delete mark", mode = "n" },
  { "<leader>mD", desc = "Delete all marks", mode = "n" },
})
