-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- TMUX Navigation Keymaps
vim.g.tmux_navigator_no_mappings = 1

vim.api.nvim_set_keymap("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<silent>{Previous-Mapping}", ":<C-U>TmuxNavigatePrevious<CR>", { noremap = true })
