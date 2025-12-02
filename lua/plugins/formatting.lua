-- Formatting with conform.nvim
return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    event = "BufWritePre",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "x" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        fish = { "fish_indent" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
    init = function()
      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("conform_format_on_save", { clear = true }),
        callback = function(args)
          if vim.g.autoformat then
            require("conform").format({ bufnr = args.buf })
          end
        end,
      })
    end,
  },
}
