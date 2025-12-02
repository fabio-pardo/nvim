-- Treesitter: syntax highlighting, indentation, and more
return {
  -- Main treesitter plugin
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = ":TSUpdate",
    event = "VeryLazy",
    cmd = { "TSUpdate", "TSInstall", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      -- Use the new nvim-treesitter main branch API
      local ts = require("nvim-treesitter")
      ts.setup(opts)

      -- Install missing parsers
      local installed = ts.get_installed and ts.get_installed() or {}
      local to_install = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, opts.ensure_installed or {})

      if #to_install > 0 then
        ts.install(to_install)
      end

      -- Enable highlighting and indentation via FileType autocmd
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if lang and pcall(vim.treesitter.start, ev.buf, lang) then
            -- Treesitter started successfully, enable indent
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Treesitter text objects for navigating code
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      -- Keymaps for treesitter text objects
      local ts_move = require("nvim-treesitter-textobjects.move")

      local function map(key, query, desc)
        local next_key = "]" .. key
        local prev_key = "[" .. key
        local next_end_key = "]" .. key:upper()
        local prev_end_key = "[" .. key:upper()

        vim.keymap.set({ "n", "x", "o" }, next_key, function()
          ts_move.goto_next_start(query, "textobjects")
        end, { desc = "Next " .. desc .. " Start", silent = true })

        vim.keymap.set({ "n", "x", "o" }, prev_key, function()
          ts_move.goto_previous_start(query, "textobjects")
        end, { desc = "Prev " .. desc .. " Start", silent = true })

        vim.keymap.set({ "n", "x", "o" }, next_end_key, function()
          ts_move.goto_next_end(query, "textobjects")
        end, { desc = "Next " .. desc .. " End", silent = true })

        vim.keymap.set({ "n", "x", "o" }, prev_end_key, function()
          ts_move.goto_previous_end(query, "textobjects")
        end, { desc = "Prev " .. desc .. " End", silent = true })
      end

      map("f", "@function.outer", "Function")
      map("c", "@class.outer", "Class")
      map("a", "@parameter.inner", "Parameter")
    end,
  },

  -- Auto-close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
}
