-- This function gets called by the plugin when a new result from fd is received
-- You can change the filename displayed here to what you like.
-- Here in the example for linux/mac we replace the home directory with '~' and remove the /bin/python part.
local function shorter_name(filename)
  return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
end

return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  ft = "python",
  keys = {
    { "cv", "<cmd>VenvSelect<cr>", desc = "Select Python virtualenv" },
  },
  opts = {
    options = {
      on_telescope_result_callback = shorter_name,
    },
  },
}
