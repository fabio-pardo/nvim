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
    session_lens = {
      mappings = {
        delete_session = { "i", "<C-d>" },
        alternate_session = { "i", "<C-s>" },
        copy_session = { "i", "<C-y>" },
      },
    },
  },
}
