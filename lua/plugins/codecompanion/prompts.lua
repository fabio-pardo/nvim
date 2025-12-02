local M = {}

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

local ROLE = {
  USER = "user",
  LLM = "llm",
}

local STRATEGY = {
  CHAT = "chat",
  WORKFLOW = "workflow",
}

--------------------------------------------------------------------------------
-- Prompt Templates
--------------------------------------------------------------------------------

local PROMPTS = {
  COMMIT_MESSAGE = [[Write a commit message for the staged changes using the commitizen convention.

Requirements:
- Use the format: <type>(<scope>): <description>
- Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Keep the subject line under 72 characters
- Explain the 'what' and 'why', not just the 'how'
- If there are breaking changes, add a BREAKING CHANGE footer]],

  COMMIT_AND_PUSH = [[⚠️ CRITICAL INSTRUCTIONS:
- Do NOT use `git add` or stage any files - they are already staged
- Do NOT modify any files

Execute these commands in order using the @cmd_runner tool:
1. `git commit -m "<commit_message>"` - use the commit message from the previous response
2. `git push`

Do NOT execute any other git commands.]],
}

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

---Get the staged diff from git
---@return string
local function get_staged_diff()
  local result = vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()
  return result.stdout or ""
end

---Check if there are staged changes
---@return boolean
local function has_staged_changes()
  local result = vim.system({ "git", "diff", "--cached", "--quiet" }, { text = true }):wait()
  return result.code ~= 0
end

--------------------------------------------------------------------------------
-- Prompt Library
--------------------------------------------------------------------------------

M.PROMPT_LIBRARY = {
  -------------------------------------------------
  -- Chat Prompts
  -------------------------------------------------
  ["Generate a Commit Message"] = {
    strategy = STRATEGY.CHAT,
    description = "Generate a commit message for staged changes",
    opts = {
      is_slash_cmd = true,
      short_name = "commit",
      auto_submit = true,
      adapter = {
        name = "copilot",
        model = "claude-sonnet-4",
      },
    },
    prompts = {
      {
        role = ROLE.USER,
        content = function()
          if not has_staged_changes() then
            return "No staged changes found. Please stage some changes first with `git add`."
          end

          return string.format(
            [[%s

````diff
%s
````]],
            PROMPTS.COMMIT_MESSAGE,
            get_staged_diff()
          )
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },

  -------------------------------------------------
  -- Workflows
  -------------------------------------------------
  ["Commit and Push"] = {
    strategy = STRATEGY.WORKFLOW,
    description = "Generate commit message, commit, and push in one go",
    opts = {
      is_slash_cmd = true,
      short_name = "commit-push",
    },
    prompts = {
      -- Step 1: Generate the commit message
      {
        {
          role = ROLE.USER,
          content = function()
            if not has_staged_changes() then
              return "No staged changes found. Please stage some changes first with `git add`."
            end

            return string.format(
              [[%s

````diff
%s
````]],
              PROMPTS.COMMIT_MESSAGE,
              get_staged_diff()
            )
          end,
          opts = {
            contains_code = true,
          },
        },
      },
      -- Step 2: Commit and push using the generated message
      {
        {
          role = ROLE.USER,
          content = PROMPTS.COMMIT_AND_PUSH,
        },
      },
    },
  },
}

return M
