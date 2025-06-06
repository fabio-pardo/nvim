return {
  {
    "mrjones2014/legendary.nvim", -- A command palette for keymaps, commands and autocmds
    priority = 10000,
    lazy = false,
    dependencies = "kkharji/sqlite.lua",
    keys = {
      {
        "<C-p>",
        function()
          require("legendary").find()
        end,
        desc = "Open Legendary",
      },
    },
    config = function()
      require("legendary").setup({
        -- select_prompt = "Legendary",
        include_builtin = false,
        extensions = {
          codecompanion = false,
          lazy_nvim = true,
          which_key = false,
        },
        -- Load these with the plugin to ensure they are loaded before any Neovim events
        autocmds = require("config.autocmds"),
      })
    end,
  },
}
