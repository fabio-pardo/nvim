-- LSP: Language Server Protocol configuration
return {
  -- Main LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    opts = {
      -- Diagnostics configuration
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      -- Inlay hints
      inlay_hints = {
        enabled = true,
        exclude = { "vue" },
      },
      -- Server configurations (using new vim.lsp.config API)
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Configure diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Setup LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(event)
          local buffer = event.buf
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc, silent = true })
          end

          -- stylua: ignore start
          map("n", "<leader>cl", function() Snacks.picker.lsp_config() end, "Lsp Info")
          map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
          map("n", "gy", vim.lsp.buf.type_definition, "Goto T[y]pe Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
          map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
          map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, "Next Reference")
          map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, "Prev Reference")
          -- stylua: ignore end
        end,
      })

      -- Enable inlay hints on attach
      if opts.inlay_hints.enabled then
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("lsp_inlay_hints", { clear = true }),
          callback = function(event)
            local buffer = event.buf
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end,
        })
      end

      -- Configure servers using the new vim.lsp.config API (Neovim 0.11+)
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          vim.lsp.config(server, server_opts)
          vim.lsp.enable(server)
        end
      end
    end,
  },

  -- Mason: package manager for LSP servers, formatters, linters
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        -- Use Mason package names (not LSP server names)
        "basedpyright", -- Python LSP
        "bash-language-server",
        "lua-language-server",
        "ruff", -- Python linter/formatter (not LSP)
        "shellcheck",
        "shfmt",
        "stylua",
        "vectorcode",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Mason-lspconfig: bridge between mason and lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    opts = {
      automatic_enable = {
        -- Exclude ruff LSP - we use it as a linter/formatter instead
        exclude = { "ruff" },
      },
    },
  },
}
