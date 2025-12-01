local CONSTANTS = {
  USER = {
    COMMIT_STAGED = "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'.",
  },
}

local function git_template(text, args)
  return function()
    return text .. "\n\n````\n" .. vim.fn.system("git diff " .. (args or "")) .. "\n````"
  end
end

PROMPT_LIBRARY = {
  ["Generate a Commit Message for Staged"] = {
    strategy = "chat",
    description = "Generate a commit message for staged change",
    opts = {
      short_name = "staged-commit",
      auto_submit = true,
      is_slash_cmd = true,
    },
    prompts = {
      {
        role = "user",
        content = git_template(CONSTANTS.USER.COMMIT_STAGED, "--staged"),
        opts = {
          contains_code = true,
        },
      },
    },
  },
}

return {
  PROMPT_LIBRARY = PROMPT_LIBRARY,
}
