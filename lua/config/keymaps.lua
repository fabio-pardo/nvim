-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
wk.add({
  { "<leader>o", group = "Obsidian", icon = "🔮" },

  { "<leader>a", group = "AI Code Companion", icon = "🤖" },

  { "<leader>m", group = "Marks", icon = "📍" },
  { "<leader>mm", desc = "List marks" },
  { "<leader>md", desc = "Delete mark" },
  { "<leader>mD", desc = "Delete all marks" },

  -- AutoSession keymaps
  { "<leader>qa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
  { "<leader>qd", "<cmd>AutoSession deletePicker<CR>", desc = "Session delete" },
  { "<leader>qk", "<cmd>AutoSession save<CR>", desc = "Save session" },
  { "<leader>qs", "<cmd>AutoSession restore<CR>", desc = "Session restore" },
  { "<leader>qS", "<cmd>AutoSession search<CR>", desc = "Session search" },
})
