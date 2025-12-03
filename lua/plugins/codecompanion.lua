local DEPS = require("plugins.codecompanion.dependencies")
local KEYS = require("plugins.codecompanion.keymaps")
local OPTS = require("plugins.codecompanion.opts")
local SPINNER = require("plugins.codecompanion.spinner")

return {
  "olimorris/codecompanion.nvim",
  version = "v17.33.0", -- recommended, use latest release instead of latest commit
  config = function()
    SPINNER()
    require("codecompanion").setup(OPTS)
  end,
  dependencies = DEPS,
  keys = KEYS,
}
