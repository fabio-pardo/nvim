return {
  "rmagatti/auto-session",
  lazy = false,
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    auto_restore = true,
    auto_restore_last_session = true,
    git_use_branch_name = true, -- Use the current branch name as the session name
  },
  keys = {
    { "<leader>qa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    { "<leader>qd", "<cmd>AutoSession deletePicker<CR>", desc = "Session delete" },
    { "<leader>qk", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>qs", "<cmd>AutoSession restore<CR>", desc = "Session restore" },
    { "<leader>qS", "<cmd>AutoSession search<CR>", desc = "Session search" },
  },
}
