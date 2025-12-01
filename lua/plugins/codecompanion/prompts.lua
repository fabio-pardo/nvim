local CONSTANTS = {
  USER = {
    ROLE = "user",
    COMMIT_STAGED = "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'.",
    COMMIT_PUSH = "Using @{cmd_runner}, generate the git commands to commit the changes with the generated message and push to the remote.",
  },
  STRATEGY = {
    CHAT = "chat",
    WORKFLOW = "workflow",
  },
}

PROMPT_LIBRARY = {
  ["Commit and Push Staged Changes"] = {
    strategy = CONSTANTS.STRATEGY.CHAT,
    description = "Commit and push staged changes",
    opts = {
      adapter = {
        name = "copilot",
        model = "claude-haiku-4.5",
      },
      auto_submit = true,
      is_slash_cmd = true,
      short_name = "commit-push",
    },
    prompts = {
      {
        role = CONSTANTS.USER.ROLE,
        content = function()
          vim.g.codecompanion_yolo_mode = true
          return CONSTANTS.USER.COMMIT_PUSH
        end,
      },
    },
  },
}

return {
  PROMPT_LIBRARY = PROMPT_LIBRARY,
}
