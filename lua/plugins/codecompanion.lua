local CODECOMPANION_DEPENDANCIES = require("plugins.code-companion.dependencies")
local OPTS = require("plugins.code-companion.opts")
local KEYS = require("plugins.code-companion.keys")

return {
  "olimorris/codecompanion.nvim",
  dependencies = CODECOMPANION_DEPENDANCIES,
  opts = OPTS,
  keys = KEYS,
  config = function(_, opts)
    local spinner = require("plugins.code-companion.spinner")
    spinner:init()

    -- Setup the entire opts table
    require("codecompanion").setup(opts)
  end,
}
