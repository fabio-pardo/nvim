local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip", -- handles .gz file compression
        "matchit", -- enhanced % matching for brackets/tags
        "matchparen", -- highlights matching parentheses
        "netrwPlugin", -- built-in file explorer
        "tarPlugin", -- handles .tar file archives
        "tohtml", -- converts buffer to HTML
        "tutor", -- Neovim's built-in tutorial
        "zipPlugin", -- handles .zip file archives
      },
    },
  },
})

-- keymaps and utils can be loaded, lazily, after plugins
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
    require("util")
    -- Show hidden and ignored files
    require("snacks").picker.sources.files.hidden = true
    require("snacks").picker.sources.files.ignored = true
  end,
})
