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
}
