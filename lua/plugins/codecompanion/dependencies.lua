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
    ft = { "markdown", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    config = function()
      -- Setup
      require("render-markdown").setup({
        enabled = true,
        file_types = { "markdown", "codecompanion" },
        render_modes = true,
        win_options = {
          conceallevel = { rendered = 2 },
          concealcursor = { rendered = "nc" },
        },
        anti_conceal = {
          -- Preserve glyphs in normal mode but make them "anti_conceal" in insert mode to
          -- replicate concealcursor behaviour
          ignore = {
            bullet = { "n" },
            callout = { "n" },
            check_icon = { "n" },
            check_scope = { "n" },
            code_language = { "n" },
            dash = { "n" },
            head_icon = { "n" },
            link = { "n" },
            quote = { "n" },
            table_border = { "n" },
          },
        },
        dash = {
          width = 80,
        },
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
        code = {
          sign = false,
          width = "block",
          border = "thick",
          min_width = 80,
          highlight_language = "LineNr",
          language_name = false,
        },
        quote = { icon = "▐" },
        pipe_table = { cell = "raw" },
        link = {
          wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
          custom = {
            gdrive = {
              pattern = "drive%.google%.com/drive",
              icon = " ",
            },
            spreadsheets = {
              pattern = "docs%.google%.com/spreadsheets",
              icon = "󰧷 ",
            },
            document = {
              pattern = "docs%.google%.com/document",
              icon = "󰈙 ",
            },
            presentation = {
              pattern = "docs%.google%.com/presentation",
              icon = "󰈩 ",
            },
          },
        },
        latex = { enabled = false },
        html = { comment = { conceal = false } },
        on = {
          render = function(ctx)
            local is_lsp_float = pcall(vim.api.nvim_win_get_var, ctx.win, "lsp_floating_bufnr")
            if is_lsp_float then
              _G.LspConfig.highlight_doc_patterns(ctx.buf)
            end
          end,
        },
        overrides = {
          filetype = {
            -- CodeCompanion
            codecompanion = {
              heading = {
                icons = { "󰪥 ", "", " ", " ", " ", "" },
                -- custom = {
                --   codecompanion_input = {
                --     pattern = "^## Me$",
                --     icon = " ",
                --   },
                -- },
              },
              html = {
                tag = {
                  buf = { icon = " ", highlight = "CodeCompanionChatVariable" },
                  file = { icon = " ", highlight = "CodeCompanionChatVariable" },
                  help = { icon = "󰘥 ", highlight = "CodeCompanionChatVariable" },
                  image = { icon = " ", highlight = "CodeCompanionChatVariable" },
                  symbols = { icon = " ", highlight = "CodeCompanionChatVariable" },
                  url = { icon = "󰖟 ", highlight = "CodeCompanionChatVariable" },
                  var = { icon = " ", highlight = "CodeCompanionChatVariable" },
                  tool = { icon = " ", highlight = "CodeCompanionChatTool" },
                  user = { icon = " ", highlight = "CodeCompanionChatTool" },
                  group = { icon = " ", highlight = "CodeCompanionChatToolGroup" },
                },
              },
            },
          },
        },
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
