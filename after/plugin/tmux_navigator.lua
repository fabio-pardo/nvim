vim.g.tmux_navigator_no_mappings = 1

vim.api.nvim_set_keymap('n', '<silent>{Left-Mapping}', ':<C-U>TmuxNavigateLeft<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<silent>{Down-Mapping}', ':<C-U>TmuxNavigateDown<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<silent>{Up-Mapping}', ':<C-U>TmuxNavigateUp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<silent>{Right-Mapping}', ':<C-U>TmuxNavigateRight<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<silent>{Previous-Mapping}', ':<C-U>TmuxNavigatePrevious<CR>', { noremap = true })