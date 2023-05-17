local vim = vim
vim.g.tmux_navigator_no_mappings = 1

vim.api.nvim_set_keymap("n", "{Left-Mapping}", ":<C-U>TmuxNavigateLeft<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "{Down-Mapping}", ":<C-U>TmuxNavigateDown<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "{Up-Mapping}", ":<C-U>TmuxNavigateUp<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "{Right-Mapping}", ":<C-U>TmuxNavigateRight<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "{Previous-Mapping}", ":<C-U>TmuxNavigatePrevious<cr>", { silent = true })
