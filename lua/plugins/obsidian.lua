local prefix = "<leader>o"

-- filepath: lua/plugins/obsidian.lua
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  keys = {
    { prefix .. "o", "<cmd>Obsidian open<CR>", desc = "Open on App" },
    { prefix .. "g", "<cmd>Obsidian search<CR>", desc = "Grep" },
    { prefix .. "n", "<cmd>Obsidian new<CR>", desc = "New Note" },
    { prefix .. "N", "<cmd>Obsidian new_from_template<CR>", desc = "New Note (Template)" },
    { prefix .. "<space>", "<cmd>Obsidian quick_switch<CR>", desc = "Find Files" },
    { prefix .. "b", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
    { prefix .. "t", "<cmd>Obsidian tags<CR>", desc = "Tags" },
    { prefix .. "T", "<cmd>Obsidian template<CR>", desc = "Template" },
    { prefix .. "L", "<cmd>Obsidian link<CR>", mode = "v", desc = "Link" },
    { prefix .. "l", "<cmd>Obsidian links<CR>", desc = "Links" },
    { prefix .. "k", "<cmd>Obsidian link_new<CR>", mode = "v", desc = "New Link" },
    { prefix .. "e", "<cmd>Obsidian extract_note<CR>", mode = "v", desc = "Extract Note" },
    { prefix .. "w", "<cmd>Obsidian workspace<CR>", desc = "Workspace" },
    { prefix .. "r", "<cmd>Obsidian rename<CR>", desc = "Rename" },
    { prefix .. "i", "<cmd>Obsidian paste_img<CR>", desc = "Paste Image" },
    { prefix .. "d", "<cmd>Obsidian dailies<CR>", desc = "Daily Notes" },
  },
  opts = {
    -- Disable legacy commands (ObsidianX) in favour of new format (Obsidian x)
    legacy_commands = false,
    workspaces = {
      {
        -- name = "old_notes",
        -- path = "~/vaults/notes",
      },
      {
        name = "personal",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/my_vault",
      },
      {
        name = "qued",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/qued",
        overrides = {
          daily_notes = {
            workdays_only = true,
          },
        },
      },
      {
        name = "vv",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/vv",
        overrides = {
          daily_notes = {
            workdays_only = true,
          },
        },
      },
    },
    log_level = vim.log.levels.INFO,
    completion = {
      -- Disables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
      -- Set to false to disable new note creation in the picker
      create_new = true,
    },

    -- New notes go into the Notes subdirectory
    notes_subdir = "Notes",
    new_notes_location = "notes_subdir",

    -- Daily notes configuration
    daily_notes = {
      folder = "2. areas/daily", -- Daily notes go to the "Daily" folder
      date_format = "%Y-%m-%d", -- Format for daily note filenames
      alias_format = "%B %-d, %Y", -- Format for the alias (e.g., "December 8, 2025")
      default_tags = { "daily" }, -- Tags to add to daily notes
      workdays_only = false, -- Set true to skip weekends with yesterday/tomorrow commands
    },

    -- Prepend date to new note filenames
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      local date = os.date("%Y-%m-%d")
      if title ~= nil and title ~= "" then
        local suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        return date .. "-" .. suffix
      end
      -- Random suffix if no title provided
      local suffix = ""
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
      return date .. "-" .. suffix
    end,
    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "wiki",
    -- templates = {
    --   folder = "Templates",
    -- },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = "snacks.pick",
    },
  },
}
