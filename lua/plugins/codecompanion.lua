local DEPS = require("plugins.codecompanion.dependencies")
local KEYS = require("plugins.codecompanion.keys")
local spinner = require("plugins.codecompanion.spinner")

return {
  "olimorris/codecompanion.nvim",
  keys = KEYS,
  dependencies = DEPS,
  config = function()
    spinner()
    local opts = require("plugins.codecompanion.opts")
    require("codecompanion").setup(opts)
  end,
}
