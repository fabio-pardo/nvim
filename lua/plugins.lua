return {

  { "lewis6991/impatient.nvim" },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "christoomey/vim-tmux-navigator", lazy = false},
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "RRethy/nvim-treesitter-textsubjects",
      "RRethy/nvim-treesitter-endwise",
    },
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      require "config.plugins.treesitter"
    end,
  },
  { "neovim/nvim-lspconfig", 		   -- LSP configurations
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",  	   -- Installer for external tools
      "williamboman/mason-lspconfig.nvim", -- mason extension for lspconfig
      "hrsh7th/nvim-cmp",                  -- Autocomplete engine
      "hrsh7th/cmp-nvim-lsp",              -- Completion source for LSP
      "L3MON4D3/LuaSnip",                  -- Snippet engine
    }
  },
}
