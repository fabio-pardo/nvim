local mapping_key_prefix = vim.g.ai_prefix_key or "<leader>a"

local PROMPTS = require("plugins.code-companion.prompts")

local adapter = "copilot"

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        spec = {
          { mapping_key_prefix, group = "AI Code Companion", mode = { "n", "v" } },
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = { ensure_installed = { "yaml", "markdown" } },
    },
    {
      "echasnovski/mini.diff",
      config = function()
        local diff = require("mini.diff")
        diff.setup({
          -- Disabled by default
          source = diff.gen_source.none(),
        })
      end,
    },
    -- {
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   ft = { "markdown", "codecompanion" },
    --   opts = {
    --     render_modes = true, -- Render in ALL modes
    --     sign = {
    --       enabled = false, -- Turn off in the status column
    --     },
    --   },
    -- },
    {
      "folke/edgy.nvim",
      optional = true,
      opts = function(_, opts)
        opts.animate = { enabled = false }
        opts.right = opts.right or {}
        table.insert(opts.right, {
          ft = "codecompanion",
          title = "Companion Chat",
          size = { width = 70 },
        })
      end,
    },
    "j-hui/fidget.nvim", -- Display status
    {
      "saghen/blink.cmp",
      lazy = false,
      version = "*",
      opts = {
        keymap = {
          preset = "enter",
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<Tab>"] = { "select_next", "fallback" },
        },
        cmdline = { sources = { "cmdline" } },
        sources = {
          default = { "lsp", "path", "buffer", "codecompanion" },
        },
      },
    },
    "ravitemer/codecompanion-history.nvim", -- Save and load conversation history
    {
      "ravitemer/mcphub.nvim",
      cmd = "MCPHub",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
      config = function()
        require("mcphub").setup()
      end,
    },
    {
      "Davidyz/VectorCode", -- Index and search code in your repositories
      version = "*",
      build = "pipx upgrade vectorcode",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "HakonHarnes/img-clip.nvim", -- Share images with the chat buffer
      event = "VeryLazy",
      cmd = "PasteImage",
      opts = {
        filetypes = {
          codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
          },
        },
      },
    },
  },
  opts = {
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
        adapter = adapter,
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
        adapter = adapter,
      },
      cmd = {
        adapter = adapter,
      },
      agent = {
        adapter = adapter,
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
          keymap = "gh",
          save_chat_keymap = "sc",
          auto_save = false,
          auto_generate_title = true,
          continue_last_chat = false,
          delete_on_clearing_chat = false,
          picker = "snacks",
          enable_logging = false,
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        },
      },
      vectorcode = {
        opts = {
          add_tool = true,
        },
      },
    },
    prompt_library = PROMPTS.PROMPT_LIBRARY,
  },
  keys = {
    -- Recommend setup
    {
      mapping_key_prefix .. "p",
      "<cmd>CodeCompanionActions<cr>",
      desc = "Code Companion - Prompt Actions",
    },
    {
      mapping_key_prefix .. "a",
      function()
        vim.cmd("CodeCompanionChat Toggle")
        vim.cmd("startinsert")
      end,
      desc = "Code Companion - Toggle",
      mode = { "n", "v" },
    },
    -- Some common usages with visual mode
    {
      mapping_key_prefix .. "e",
      "<cmd>CodeCompanion /explain<cr>",
      desc = "Code Companion - Explain code",
      mode = "v",
    },
    {
      mapping_key_prefix .. "f",
      "<cmd>CodeCompanion /fix<cr>",
      desc = "Code Companion - Fix code",
      mode = "v",
    },
    {
      mapping_key_prefix .. "l",
      "<cmd>CodeCompanion /lsp<cr>",
      desc = "Code Companion - Explain LSP diagnostic",
      mode = { "n", "v" },
    },
    {
      mapping_key_prefix .. "t",
      "<cmd>CodeCompanion /tests<cr>",
      desc = "Code Companion - Generate unit test",
      mode = "v",
    },
    {
      mapping_key_prefix .. "m",
      "<cmd>CodeCompanion /commit<cr>",
      desc = "Code Companion - Git commit message",
    },
    -- Custom prompts
    {
      mapping_key_prefix .. "M",
      "<cmd>CodeCompanion /staged-commit<cr>",
      desc = "Code Companion - Git commit message (staged)",
    },
    {
      mapping_key_prefix .. "d",
      "<cmd>CodeCompanion /inline-doc<cr>",
      desc = "Code Companion - Inline document code",
      mode = "v",
    },
    { mapping_key_prefix .. "D", "<cmd>CodeCompanion /doc<cr>", desc = "Code Companion - Document code", mode = "v" },
    {
      mapping_key_prefix .. "r",
      "<cmd>CodeCompanion /refactor<cr>",
      desc = "Code Companion - Refactor code",
      mode = "v",
    },
    {
      mapping_key_prefix .. "R",
      "<cmd>CodeCompanion /review<cr>",
      desc = "Code Companion - Review code",
      mode = "v",
    },
    {
      mapping_key_prefix .. "n",
      "<cmd>CodeCompanion /naming<cr>",
      desc = "Code Companion - Better naming",
      mode = "v",
    },
    -- Quick chat
    {
      mapping_key_prefix .. "q",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          vim.cmd("CodeCompanion " .. input)
        end
      end,
      desc = "Code Companion - Quick chat",
    },
  },
  config = function(_, opts)
    local spinner = require("plugins.code-companion.spinner")
    spinner:init()

    -- Setup the entire opts table
    require("codecompanion").setup(opts)
  end,
}
