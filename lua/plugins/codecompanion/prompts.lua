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

local function git_template(text, args)
  return function()
    return text .. "\n\n````\n" .. vim.fn.system("git diff " .. (args or "")) .. "\n````"
  end
end

PROMPT_LIBRARY = {
  ["Generate a Commit Message for Staged"] = {
    strategy = CONSTANTS.STRATEGY.CHAT,
    description = "Generate a commit message for staged changes",
    opts = {
      adapter = {
        name = "copilot",
        model = "claude-haiku-4.5",
      },
      auto_submit = true,
      is_slash_cmd = true,
      short_name = "staged-commit",
    },
    prompts = {
      {
        {
          role = CONSTANTS.USER.ROLE,
          content = git_template(CONSTANTS.USER.COMMIT_STAGED, "--staged"),
          opts = {
            contains_code = true,
          },
        },
      },
      {
        {
          role = CONSTANTS.USER.ROLE,
          content = "Using @{cmd_runner}, generate the git commands to commit the changes with the generated message and push to the remote.",
          opts = {
            auto_submit = false,
          },
        },
      },
    },
  },
}

return {
  PROMPT_LIBRARY = PROMPT_LIBRARY,
}
