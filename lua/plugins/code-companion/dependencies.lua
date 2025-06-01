local mapping_key_prefix = vim.g.ai_prefix_key or "<leader>a"

local CODECOMPANION_DEPENDENCIES = {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {},
  },
  { "j-hui/fidget.nvim" }, -- Disply status
  { "nvim-lua/plenary.nvim", branch = "master" },
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "yaml", "markdown" } } },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim", -- Make Markdown buffers look beautiful
    ft = { "markdown", "codecompanion" },
    opts = {
      render_modes = true, -- Render in ALL modes
      sign = {
        enabled = false, -- Turn off in the status column
      },
    },
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
  {
    "HakonHarnes/img-clip.nvim",
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
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
        default = { "lsp", "path", "buffer" },
      },
      completions = { blink = { enabled = true } },
    },
  },
  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "pipx upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "ravitemer/codecompanion-history.nvim", -- Save and load conversation history
  },
}

return CODECOMPANION_DEPENDENCIES
