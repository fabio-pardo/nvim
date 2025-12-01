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
  ["Generate a Commit Message"] = {
    strategy = CONSTANTS.STRATEGY.CHAT,
    description = "Generate a commit message",
    opts = {
      is_slash_cmd = true,
      short_name = "staged-commit",
      auto_submit = true,
      adapter = {
        name = "copilot",
        model = "claude-haiku-4.5",
      },
    },
    prompts = {
      {
        {
          role = CONSTANTS.USER_ROLE,
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
            contains_code = true,
          },
        },
      },
    },
  },
  ["Commit and Push"] = {
    strategy = CONSTANTS.STRATEGY.CHAT,
    description = "Generate a commit message for staged changes",
    opts = {
      -- auto_submit = true,
      is_slash_cmd = true,
      short_name = "commit-and-push",
    },
    prompts = {
      {
        role = CONSTANTS.USER.ROLE,
        content = function()
          return [[⚠️ CRITICAL: Do NOT use `git add` or stage any files. The files are already staged.

Execute these commands in order:
1. `git commit -m "..."` (use the generated message above)
2. `git push`

Do NOT execute any other git commands. Use the the @{cmd_runner} tool tool.]]
        end,
        opts = {
          auto_submit = true,
          contains_code = true,
        },
      },
    },
  },
}

return {
  PROMPT_LIBRARY = PROMPT_LIBRARY,
}
