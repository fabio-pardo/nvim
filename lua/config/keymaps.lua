-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
wk.add({
  -- General groups
  { "<leader>o", group = "Obsidian", icon = "🔮" },
  { "<leader>a", group = "AI Code Companion", icon = "🤖" },

  -- Marks keymaps
  {
    mode = { "n" },
    { "<leader>m", group = "Marks", icon = "📍" },
    { "<leader>mm", desc = "List marks" },
    { "<leader>md", desc = "Delete mark" },
    { "<leader>mD", desc = "Delete all marks" },
  },

  -- AutoSession keymaps
  {
    mode = { "n" },
    { "<leader>qa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    { "<leader>qd", "<cmd>AutoSession deletePicker<CR>", desc = "Session delete" },
    { "<leader>qk", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>qs", "<cmd>AutoSession restore<CR>", desc = "Session restore" },
    { "<leader>qS", "<cmd>AutoSession search<CR>", desc = "Session search" },
  },

  -- TMUX Navigation keymaps
  {
    mode = { "n" },
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate to left Tmux pane" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate to down Tmux pane" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate to up Tmux pane" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate to right Tmux pane" },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate to previous Tmux pane" },
  },
})
