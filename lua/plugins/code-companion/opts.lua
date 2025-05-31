PROMPTS = require("plugins.code-companion.prompts")
local ADAPTER = "copilot"

local OPTS = {
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = "cmd:op read op://personal/Anthropic_API/credential --no-newline",
        },
      })
    end,
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-sonnet-4",
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = ADAPTER,
      roles = {
        llm = function(adapter)
          return string.format(
            "  %s%s",
            adapter.formatted_name,
            adapter.parameters and (adapter.parameters.model and " (" .. adapter.parameters.model .. ")" or "") or ""
          )
        end,
        user = "  Sandworm", -- .. vim.env.USER:gsub("^%l", string.upper),
      },
      icons = {
        pinned_buffer = " ",
        watched_buffer = "👀 ",
      },
      slash_commands = {
        ["buffer"] = {
          keymaps = {
            modes = {
              i = "<C-b>",
            },
          },
        },
        ["fetch"] = {
          keymaps = {
            modes = {
              i = "<C-f>",
            },
          },
        },
        ["help"] = {
          opts = {
            max_lines = 1000,
          },
        },
        ["image"] = {
          keymaps = {
            modes = {
              i = "<C-i>",
            },
          },
          opts = {
            dirs = { "~/Documents/Screenshots" },
          },
        },
      },
      keymaps = {
        send = {
          callback = function(chat)
            vim.cmd("stopinsert")
            chat:submit()
          end,
          index = 1,
          description = "Send",
        },
        close = {
          modes = {
            n = "q",
          },
          index = 3,
          callback = "keymaps.close",
          description = "Close Chat",
        },
        stop = {
          modes = {
            n = "<C-c>",
          },
          index = 4,
          callback = "keymaps.stop",
          description = "Stop Request",
        },
      },
      -- -- Alter the sizing of the debug window
      -- debug_window = {
      --   ---@return number|fun(): number
      --   width = vim.o.columns - 5,
      --   ---@return number|fun(): number
      --   height = vim.o.lines - 2,
      -- },
    },
    inline = {
      adapter = ADAPTER,
    },
    cmd = {
      adapter = ADAPTER,
    },
    agent = {
      adapter = ADAPTER,
    },
  },
  inline = {
    layout = "buffer", -- vertical|horizontal|buffer
  },
  display = {
    chat = {
      intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
      show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
      separator = "─", -- The separator between the different messages in the chat buffer
      show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
      show_settings = false, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      start_in_insert_mode = false, -- Open the chat buffer in insert mode?
      -- Change to true to show the current model
      window = {
        layout = "vertical", -- float|vertical|horizontal|buffer
      },
    },
    action_palette = {
      provider = "default",
    },
    diff = {
      provider = "mini_diff",
    },
  },
  opts = {
    log_level = "DEBUG",
    system_prompt = PROMPTS.SYSTEM_PROMPT,
  },
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        show_result_in_chat = true, -- Show mcp tool results in chat
        make_vars = true, -- Convert resources to #variables
        make_slash_commands = true, -- Add prompts as /slash commands
      },
    },
    history = {
      enabled = true,
      opts = {
        -- Keymap to open history from chat buffer (default: gh)
        keymap = "gh",
        -- Keymap to save the current chat manually (when auto_save is disabled)
        save_chat_keymap = "sc",
        -- Save all chats by default (disable to save only manually using 'sc')
        auto_save = true,
        -- Number of days after which chats are automatically deleted (0 to disable)
        expiration_days = 0,
        -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
        picker = "telescope",
        ---Automatically generate titles for new chats
        auto_generate_title = true,
        title_generation_opts = {
          ---Adapter for generating titles (defaults to active chat's adapter)
          adapter = nil, -- e.g "copilot"
          ---Model for generating titles (defaults to active chat's model)
          model = nil, -- e.g "gpt-4o"
        },
        ---On exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = false,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = false,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---Enable detailed logging for history extension
        enable_logging = false,
      },
    },
    vectorcode = {
      opts = {
        add_tool = true,
      },
    },
  },
  prompt_library = PROMPTS.PROMPT_LIBRARY,
}

return OPTS
