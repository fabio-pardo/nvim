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
  ["Generate a Commit Message for Staged"] = {
    strategy = CONSTANTS.STRATEGY.WORKFLOW,
    description = "Generate a commit message for staged changes",
    opts = {
      adapter = {
        name = "copilot",
        model = "claude-haiku-4.5",
      },
      -- auto_submit = true,
      is_slash_cmd = true,
      short_name = "staged-commit",
    },
    prompts = {
      {
        {
          role = CONSTANTS.USER.ROLE,
          content = function()
            local diff = vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()
            return string.format(
              [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

````diff
%s
````
]],
              diff.stdout
            )
          end,
          opts = {
            auto_submit = true,
            contains_code = true,
          },
        },
      },
      {
        {
          role = CONSTANTS.USER.ROLE,
          content = function()
            vim.g.codecompanion_yolo_mode = true
            return [[ONLY COMMIT the staged changes with the generated message and push to the remote. DO NOT ADD files to staging—they're already there. Use the @{cmd_runner} tool to execute the git commands.]]
          end,
          opts = {
            auto_submit = true,
          },
        },
      },
    },
  },
}

return {
  PROMPT_LIBRARY = PROMPT_LIBRARY,
}
