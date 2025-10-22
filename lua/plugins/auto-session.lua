return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { "<leader>qf", "<cmd>AutoSession search<CR>", desc = "Session search" },
    { "<leader>qk", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>qa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
  },
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    git_use_branch_name = true, -- Use the current branch name as the session name
    auto_restore_last_session = true,
    session_lens = {
      picker = "snacks",
      load_on_setup = true,
      previewer = false,
      mappings = {
        delete_session = { "i", "<C-D>" },
        alternate_session = { "i", "<C-S>" },
        copy_session = { "i", "<C-Y>" },
      },
      theme_conf = {
        border = true,
      },
    },
    root_dir = vim.fn.stdpath("state") .. "/sessions/",
  },
}
