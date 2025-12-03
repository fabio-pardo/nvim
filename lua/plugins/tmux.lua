return {
  "christoomey/vim-tmux-navigator",
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate to left Tmux pane" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate to down Tmux pane" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate to up Tmux pane" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate to right Tmux pane" },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate to previous Tmux pane" },
  },
}
