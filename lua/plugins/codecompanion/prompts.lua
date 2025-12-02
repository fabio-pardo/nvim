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
- If there are breaking changes, add a BREAKING CHANGE footer

⚠️ IMPORTANT:
- Do NOT run any git commands or use any tools
- Do NOT check repository status
- Simply analyse the diff provided below and respond with the commit message only]],

  COMMIT_AND_PUSH = [[⚠️ CRITICAL INSTRUCTIONS:
- Do NOT use `git add` or stage any files - they are already staged
- Do NOT modify any files
- Do NOT run `git status`, `git diff`, or any other git commands except those listed below

Execute ONLY these commands in order using the @{cmd_runner} tool:
1. `git commit -m "<commit_message>"` - use the commit message from the previous response
2. `git push`

Do NOT execute any other commands.]],
}

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------

---Get the staged diff from git
---@return string|nil diff content, or nil if no staged changes
local function get_staged_diff()
  local result = vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()
  local diff = result.stdout or ""
  if diff == "" then
    return nil
  end
  return diff
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
          local diff = get_staged_diff()
          if not diff then
            return "No staged changes found. Please stage some changes first with `git add`."
          end

          return string.format(
            [[%s

````diff
%s
````]],
            PROMPTS.COMMIT_MESSAGE,
            diff
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
      short_name = "commit-push",
      adapter = {
        name = "copilot",
        model = "gpt-4o",
      },
    },
    prompts = {
      -- Step 1: Generate the commit message
      {
        {
          role = ROLE.USER,
          content = function()
            local diff = get_staged_diff()
            if not diff then
              return "No staged changes found. Please stage some changes first with `git add`."
            end

            return string.format(
              [[%s

````diff
%s
````]],
              PROMPTS.COMMIT_MESSAGE,
              diff
            )
          end,
          opts = {
            contains_code = true,
            auto_submit = true,
          },
        },
      },
      -- Step 2: Commit and push using the generated message
      {
        {
          role = ROLE.USER,
          content = PROMPTS.COMMIT_AND_PUSH,
          opts = {
            auto_submit = true,
          },
        },
      },
    },
  },
}

return M
