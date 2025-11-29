local DEPS = require("plugins.codecompanion.dependencies")
local KEYS = require("plugins.codecompanion.keys")
local OPTS = require("plugins.codecompanion.opts")
local spinner = require("plugins.codecompanion.spinner")

return {
  "olimorris/codecompanion.nvim",
  version = "v17.33.0", -- recommended, use latest release instead of latest commit
  keys = KEYS,
  dependencies = DEPS,
  config = function()
    spinner()
    require("codecompanion").setup(OPTS)
  end,
}
