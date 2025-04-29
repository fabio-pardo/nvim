return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = "medium"
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
    debugger = {
      enabled = true,
      run_via_dap = true,
    },
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { "<leader>qf", "<cmd>SessionSearch<CR>", desc = "Session search" },
      { "<leader>qk", "<cmd>SessionSave<CR>", desc = "Save session" },
      { "<leader>qa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = true,
        previewer = false,
        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { "i", "<C-D>" },
          alternate_session = { "i", "<C-S>" },
          copy_session = { "i", "<C-Y>" },
        },
        -- Can also set some Telescope picker options
        -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        theme_conf = {
          border = true,
          -- layout_config = {
          --   width = 0.8, -- Can set width and height as percent of window
          --   height = 0.5,
          -- },
        },
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --both are optionals for debugging
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    branch = "regexp", -- This is the regexp branch, use this for the new version
    config = function()
      -- This function gets called by the plugin when a new result from fd is received
      -- You can change the filename displayed here to what you like.
      -- Here in the example for linux/mac we replace the home directory with '~' and remove the /bin/python part.
      local function shorter_name(filename)
        return filename:gsub(os.getenv("HOME"), "") --all
        -- :gsub("/bin/python", "") -- all
        -- :gsub(".virtualenvs/", "") -- venv
        -- :gsub(".pyenv/versions/", "") -- pyenv
        -- :gsub("Library/Caches/pypoetry", "") -- poetry
        -- :gsub("dev", "")
        -- :gsub("/", "")
        -- :gsub(".venv", "")
      end

      require("venv-selector").setup({
        settings = {
          options = {
            -- If you put the callback here as a global option, its used for all searches (including the default ones by the plugin)
            on_telescope_result_callback = shorter_name,
          },

          search = {
            virtualenvs = {
              command = "fd '^python$' ~/.virtualenvs --type l",
              -- If you put the callback here, its only called for your "virtualenvs" search
              on_telescope_result_callback = shorter_name,
            },
            pyenv = {
              command = "fd '^python$' ~/.pyenv --type l",
              on_telescope_result_callback = shorter_name,
            },
            poetry = {
              command = "fd '^python$' ~/Library/Caches/pypoetry/virtualenvs --type l",
              on_telescope_result_callback = shorter_name,
            },
          },
        },
      })
    end,
    keys = {
      { "cv", "<cmd>VenvSelect<cr>" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = { -- pyright but based. manually install off PyPI
          basedpyright = {
            analysis = {
              typeCheckingMode = "all", -- off, basic, standard, strict, all
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
              diagnosticsMode = "workspace", -- workspace, openFilesOnly
            },
          },
        },
      },
    },
  },
}
