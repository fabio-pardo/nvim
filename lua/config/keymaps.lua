-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add shortcut for VVNote command
local wk = require("which-key")
wk.add({
  { "<leader>v", group = "Virgin Voyages", icon = "" },
  { "<leader>vv", ":VVNote<CR>", desc = "Create Virgin Voyages note", mode = "n" },
})
