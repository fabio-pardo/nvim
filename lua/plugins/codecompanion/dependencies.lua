local DEPS = {
  { "nvim-lua/plenary.nvim" },

  { "j-hui/fidget.nvim" }, -- Disply status

  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "ravitemer/codecompanion-history.nvim", -- Save and load conversation history
  },

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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    ft = { "codecompanion", "markdown" },
    config = function()
      require("render-markdown").setup({
        completions = { blink = { enabled = true } },
        file_types = { "codecompanion", "markdown" },
        heading = {
          sign = false,
          icons = { "󰪥 ", "󰺕 ", " ", " ", " ", "" },
          position = "inline",
        },
        bullet = {
          icons = { "", "•", "", "-", "-" },
        },
        checkbox = {
          unchecked = { icon = "" },
          checked = { icon = "", scope_highlight = "@markup.strikethrough" },
          custom = {
            doing = {
              raw = "[_]",
              rendered = "󰄮",
              highlight = "RenderMarkdownDoing",
            },
            wontdo = {
              raw = "[~]",
              rendered = "󰅗",
              highlight = "RenderMarkdownWontdo",
            },
          },
        },
        overrides = {
          filetype = {
            -- CodeCompanion
            codecompanion = {
              heading = {
                icons = { "󰪥 ", "", " ", " ", " ", "" },
              },
              html = {
                tag = {
                  var = { icon = " ", highlight = "CodeCompanionChatVariable" },
                  user = { icon = " ", highlight = "CodeCompanionChatTool" },
                  buf = { icon = " ", highlight = "CodeCompanionChatIcon" },
                  file = { icon = " ", highlight = "CodeCompanionChatIcon" },
                  group = { icon = " ", highlight = "CodeCompanionChatIcon" },
                  help = { icon = "󰘥 ", highlight = "CodeCompanionChatIcon" },
                  image = { icon = " ", highlight = "CodeCompanionChatIcon" },
                  memory = { icon = "󰧑 ", highlight = "CodeCompanionChatIcon" },
                  symbols = { icon = " ", highlight = "CodeCompanionChatIcon" },
                  tool = { icon = "󰯠 ", highlight = "CodeCompanionChatIcon" },
                  url = { icon = "󰌹 ", highlight = "CodeCompanionChatIcon" },
                },
              },
            },
          },
        },
        render_modes = true,
        sign = { enabled = false },
      })
    end,
  },

  {
    "nvim-mini/mini.diff",
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
}
return DEPS
