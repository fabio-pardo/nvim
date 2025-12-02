---@diagnostic disable: undefined-doc-name
local ADAPTER = "gemini"
local GEMINI_DEFAULT_MODEL = "gemini-3-pro-preview"
local COPILOT_DEFAULT_MODEL = GEMINI_DEFAULT_MODEL

local PROMPTS = require("plugins.codecompanion.prompts")

local OPTS = {
  adapters = {
    http = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = COPILOT_DEFAULT_MODEL,
            },
          },
        })
      end,
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
      openrouter = function()
        return require("plugins.codecompanion.openrouter")
      end,
      tavily = function()
        return require("codecompanion.adapters").extend("tavily", {
          env = {
            api_key = "cmd:op read op://personal/Tavily_API/credential --no-newline",
          },
        })
      end,
    },
  },
  display = {
    action_palette = {
      provider = "default",
    },
    chat = {
      fold_context = false, -- Fold context messages in the chat buffer?
      intro_message = "",
      separator = "─", -- The separator between the different messages in the chat buffer
      show_context = true, -- Show context (from slash commands and variables) in the chat buffer?
      show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
      show_settings = false, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      show_tools_processing = true, -- Show the loading message when tools are being executed?
      start_in_insert_mode = false, -- Open the chat buffer in insert mode?
    },
  },
  extensions = {
    history = { -- Code Companion History Extension
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
          adapter = "copilot", -- "copilot"
          ---Model for generating titles (defaults to current chat model)
          model = "gpt-4o", -- "gpt-4o"
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
        delete_on_clearing_chat = true,
        ---Directory path to save the chats
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        ---Enable detailed logging for history extension
        enable_logging = true,

        -- Summary system
        summary = {
          -- Keymap to generate summary for current chat (default: "gcs")
          create_summary_keymap = "gcs",
          -- Keymap to browse summaries (default: "gbs")
          browse_summaries_keymap = "gbs",

          generation_opts = {
            adapter = "copilot", -- defaults to current chat adapter
            model = "gpt-4o", -- defaults to current chat model
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
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true,
      },
    },
    vectorcode = {
      ---@type VectorCode.CodeCompanion.ExtensionOpts
      opts = {
        tool_group = {
          -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
          enabled = true,
          -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
          -- if you use @vectorcode_vectorise, it'll be very handy to include
          -- `file_search` here.
          extras = {},
          collapse = false, -- whether the individual tools should be shown in the chat
        },
        tool_opts = {
          ---@type VectorCode.CodeCompanion.ToolOpts
          ["*"] = {},
          ---@type VectorCode.CodeCompanion.LsToolOpts
          ls = {},
          ---@type VectorCode.CodeCompanion.VectoriseToolOpts
          vectorise = {},
          ---@type VectorCode.CodeCompanion.QueryToolOpts
          query = {
            max_num = { chunk = -1, document = -1 },
            default_num = { chunk = 50, document = 10 },
            include_stderr = false,
            use_lsp = false,
            no_duplicate = true,
            chunk_mode = false,
            ---@type VectorCode.CodeCompanion.SummariseOpts
            summarise = {
              ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
              enabled = false,
              adapter = nil,
              query_augmented = true,
            },
          },
          files_ls = {},
          files_rm = {},
        },
      },
    },
  },
  memory = {
    opts = {
      chat = {
        enabled = true,
      },
    },
  },
  opts = {
    -- system_prompt = PROMPTS.SYSTEM_PROMPT,
    language = "British English",
    log_level = "DEBUG",
  },
  prompt_library = PROMPTS.PROMPT_LIBRARY,
  strategies = {
    chat = {
      adapter = ADAPTER,
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
        codeblock = {
          modes = { n = "gC" },
          index = 7,
          callback = "keymaps.codeblock",
          description = "Insert codeblock",
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
    },
    inline = {
      adapter = ADAPTER,
      layout = "buffer",
    },
    cmd = {
      adapter = ADAPTER,
    },
    agent = {
      adapter = ADAPTER,
    },
  },
}

return OPTS
