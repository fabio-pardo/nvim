local PROMPTS = require("plugins.codecompanion.prompts")
local ADAPTER = "gemini"
local COPILOT_DEFAULT_MODEL = "claude-sonnet-4.5"
local GEMINI_DEFAULT_MODEL = "gemini-2.5-pro"
local OPENROUTER_DEFAULT_MODEL = "qwen/qwen3-coder"

local OPTS = {
  adapters = {
    http = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "cmd:op read op://VV/Gemini_API/credential",
          },
          schema = {
            model = {
              default = GEMINI_DEFAULT_MODEL,
            },
          },
        })
      end,
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = {
            api_key = "cmd:op read op://personal/Anthropic_API/credential --no-newline",
          },
        })
      end,
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          env = {
            api_key = "cmd:op read op://personal/OpenAI_API/credential --no-newline",
          },
        })
      end,
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = COPILOT_DEFAULT_MODEL,
            },
          },
        })
      end,
      openrouter = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          formatted_name = "OpenRouter",
          env = {
            url = "https://openrouter.ai/api",
            api_key = "cmd:op read op://personal/OpenRouter_API/credential --no-newline",
            chat_url = "/v1/chat/completions",
          },
          schema = {
            model = {
              default = OPENROUTER_DEFAULT_MODEL,
            },
          },
        })
      end,
      tavily = function()
        return require("codecompanion.adapters").extend("tavily", {
          env = {
            api_key = "cmd:op read op://personal/Tavily_API/credential --no-newline",
          },
        })
      end,
      opts = {
        show_model_choices = true,
      },
    },
  },
  strategies = {
    chat = {
      adapter = ADAPTER,
      roles = {
        llm = function(adapter)
          return string.format(
            "  %s%s",
            adapter.formatted_name,
            adapter.parameters and (adapter.parameters.model and " (" .. adapter.parameters.model .. ")" or "") or ""
          )
        end,
        user = " Fabs", -- .. vim.env.USER:gsub("^%l", string.upper),
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
        regenerate = {
          modes = { n = "gl" },
          index = 3,
          callback = "keymaps.regenerate",
          description = "Regenerate last response",
        },
      },
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
      enabled = true,
      provider = "mini_diff", -- mini_diff|split|inline

      provider_opts = {
        -- Options for inline diff provider
        inline = {
          layout = "buffer", -- float|buffer - Where to display the diff

          diff_signs = {
            signs = {
              text = "▌", -- Sign text for normal changes
              reject = "✗", -- Sign text for rejected changes in super_diff
              highlight_groups = {
                addition = "DiagnosticOk",
                deletion = "DiagnosticError",
                modification = "DiagnosticWarn",
              },
            },
            -- Super Diff options
            icons = {
              accepted = " ",
              rejected = " ",
            },
            colors = {
              accepted = "DiagnosticOk",
              rejected = "DiagnosticError",
            },
          },

          opts = {
            context_lines = 3, -- Number of context lines in hunks
            dim = 25, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
            full_width_removed = true, -- Make removed lines span full width
            show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
            show_removed = true, -- Show removed lines as virtual text
          },
        },

        -- Options for the split provider
        split = {
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = "vertical", -- vertical|horizontal split
          opts = {
            "internal",
            "filler",
            "closeoff",
            "algorithm:histogram", -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
            "indent-heuristic", -- https://blog.k-nut.eu/better-git-diffs
            "followwrap",
            "linematch:120",
          },
        },
      },
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
        -- Picker interface (auto resolved to a valid picker)
        picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
        ---Optional filter function to control which chats are shown when browsing
        chat_filter = nil, -- function(chat_data) return boolean end
        -- Customize picker keymaps (optional)
        picker_keymaps = {
          rename = { n = "r", i = "<M-r>" },
          delete = { n = "d", i = "<M-d>" },
          duplicate = { n = "<C-y>", i = "<C-y>" },
        },
        ---Automatically generate titles for new chats
        auto_generate_title = true,
        title_generation_opts = {
          ---Adapter for generating titles (defaults to current chat adapter)
          adapter = nil, -- "copilot"
          ---Model for generating titles (defaults to current chat model)
          model = nil, -- "gpt-4o"
          ---Number of user prompts after which to refresh the title (0 to disable)
          refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
          ---Maximum number of times to refresh the title (default: 3)
          max_refreshes = 3,
          format_title = function(original_title)
            -- this can be a custom function that applies some custom
            -- formatting to the title.
            return original_title
          end,
        },
        ---On exiting and entering neovim, loads the last chat on opening chat
        continue_last_chat = false,
        ---When chat is cleared with `gx` delete the chat from history
        delete_on_clearing_chat = false,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---Enable detailed logging for history extension
        enable_logging = false,

        -- Summary system
        summary = {
          -- Keymap to generate summary for current chat (default: "gcs")
          create_summary_keymap = "gcs",
          -- Keymap to browse summaries (default: "gbs")
          browse_summaries_keymap = "gbs",

          generation_opts = {
            adapter = nil, -- defaults to current chat adapter
            model = nil, -- defaults to current chat model
            context_size = 90000, -- max tokens that the model supports
            include_references = true, -- include slash command content
            include_tool_outputs = true, -- include tool execution results
            system_prompt = nil, -- custom system prompt (string or function)
            format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
          },
        },

        -- Memory system (requires VectorCode CLI)
        memory = {
          -- Automatically index summaries when they are generated
          auto_create_memories_on_summary_generation = true,
          -- Path to the VectorCode executable
          vectorcode_exe = "vectorcode",
          -- Tool configuration
          tool_opts = {
            -- Default number of memories to retrieve
            default_num = 10,
          },
          -- Enable notifications for indexing progress
          notify = true,
          -- Index all existing memories on startup
          -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
          index_on_startup = false,
        },
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
