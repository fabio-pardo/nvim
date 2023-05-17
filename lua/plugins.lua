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
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
  },
}
