return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { "<leader>qf", "<cmd>SessionSearch<CR>", desc = "Session search" },
    { "<leader>qk", "<cmd>SessionSave<CR>", desc = "Save session" },
    { "<leader>qa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
  },
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    git_use_branch_name = true, -- Use the current branch name as the session name
    session_lens = {
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
  },
}
