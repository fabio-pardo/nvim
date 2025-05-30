local adapter = "anthropic"
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
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
    "nvim-treesitter/nvim-treesitter",
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
    -- { "echasnovski/mini.pick", config = true },
    -- { "ibhagwan/fzf-lua", config = true },
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
    },
    prompt_library = {
      ["Test workflow"] = {
        strategy = "workflow",
        description = "Use a workflow to test the plugin",
        opts = {
          index = 4,
        },
        prompts = {
          {
            {
              role = "user",
              content = "Generate a Python class for managing a book library with methods for adding, removing, and searching books",
              opts = {
                auto_submit = false,
              },
            },
          },
          {
            {
              role = "user",
              content = "Write unit tests for the library class you just created",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Create a TypeScript interface for a complex e-commerce shopping cart system",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Write a recursive algorithm to balance a binary search tree in Java",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Generate a comprehensive regex pattern to validate email addresses with explanations",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Create a Rust struct and implementation for a thread-safe message queue",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Write a GitHub Actions workflow file for CI/CD with multiple stages",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Create SQL queries for a complex database schema with joins across 4 tables",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Write a Lua configuration for Neovim with custom keybindings and plugins",
              opts = {
                auto_submit = true,
              },
            },
          },
          {
            {
              role = "user",
              content = "Generate documentation in JSDoc format for a complex JavaScript API client",
              opts = {
                auto_submit = true,
              },
            },
          },
        },
      },
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
        -- Alter the sizing of the debug window
        debug_window = {
          ---@return number|fun(): number
          width = vim.o.columns - 5,
          ---@return number|fun(): number
          height = vim.o.lines - 2,
        },
        -- Options to customize the UI of the chat buffer
        window = {
          layout = "vertical", -- float|vertical|horizontal|buffer
          position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
          border = "single",
          height = 0.8,
          width = 0.45,
          relative = "editor",
          full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
          opts = {
            breakindent = true,
            cursorcolumn = false,
            cursorline = false,
            foldcolumn = "0",
            linebreak = true,
            list = false,
            numberwidth = 1,
            signcolumn = "no",
            spell = false,
            wrap = true,
          },
          keymaps = {
            send = {
              modes = { n = "<C-s>", i = "<C-s>" },
            },
            close = {
              modes = { n = "<Esc>", i = "<Esc>" },
            },
            completion = {
              modes = {
                i = "<C-x>",
              },
            },
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
          tools = {
            opts = {
              auto_submit_success = false,
              auto_submit_errors = false,
            },
          },
          ---Customize how tokens are displayed
          ---@param tokens number
          ---@param adapter CodeCompanion.Adapter
          ---@return string
          token_count = function(tokens, adapter)
            return " (" .. tokens .. " tokens)"
          end,
        },
      },
      inline = {
        adapter = adapter,
      },
      cmd = {
        adapter = adapter,
      },
    },
    display = {
      action_palette = {
        provider = "default",
      },
      chat = {
        intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
        show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
        separator = "─", -- The separator between the different messages in the chat buffer
        show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
        show_settings = false, -- Show LLM settings at the top of the chat buffer?
        show_token_count = true, -- Show the token count for each response?
        start_in_insert_mode = false, -- Open the chat buffer in insert mode?
      },
      diff = {
        provider = "mini_diff",
      },
    },
    opts = {
      log_level = "DEBUG",
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
  },
  init = function()
    -- Create command abbreviation
    vim.cmd([[cab cc CodeCompanion]])
    require("legendary").keymaps({
      {
        itemgroup = "CodeCompanion",
        icon = "",
        description = "Use the power of AI...",
        keymaps = {
          {
            "<C-a>",
            "<cmd>CodeCompanionActions<CR>",
            description = "Open the action palette",
            mode = { "n", "v" },
          },
          {
            "<Leader>a",
            "<cmd>CodeCompanionChat Toggle<CR>",
            description = "Toggle a chat buffer",
            mode = { "n", "v" },
          },
          {
            "<LocalLeader>a",
            "<cmd>CodeCompanionChat Add<CR>",
            description = "Add code to a chat buffer",
            mode = { "v" },
          },
        },
      },
    })
    require("plugins.custom.spinner"):init()
  end,
}
