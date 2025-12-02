local prefix = "<leader>o"

-- Helper function to get current date
---@return string
local _current_date = function()
  return os.date("%Y-%m-%d") --[[@as string]]
end

-- Helper function to get current date with optional title suffix
---@param title string|?
---@return string
local _date_with_title = function(title)
  local date = _current_date()
  if title ~= nil and title ~= "" then
    local suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    return date .. "-" .. suffix
  end
  return date
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = ":call mkdp#util#install()",
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Set up autocommand to create subsequent notes when opening daily note
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.md",
      callback = function(ev)
        local bufname = vim.api.nvim_buf_get_name(ev.buf)

        -- Only proceed if this is in the daily notes folder
        if not bufname:match("00%-daily%-notes") then
          return
        end

        local todays_date = _current_date()
        local filename = vim.fn.fnamemodify(bufname, ":t:r") -- get filename without extension

        -- Check if this is today's daily note
        if filename == todays_date then
          local Path = require("obsidian.path")
          local Note = require("obsidian.note")

          -- Create journal note if it doesn't exist
          local journal_path = Path.new(
            vim.fn.expand(
              "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/01-journal/" .. todays_date .. ".md"
            )
          )

          if not journal_path:exists() then
            vim.schedule(function()
              Note.create({ title = todays_date, template = "01-journal.md", should_write = true })
            end)
          end

          -- Create work daily note if it's a working day
          local ObsUtil = require("obsidian.util")
          if ObsUtil.is_working_day(os.time()) then
            local work_daily_path = Path.new(
              vim.fn.expand(
                "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/02-work/00-daily-notes/"
                  .. todays_date
                  .. ".md"
              )
            )

            if not work_daily_path:exists() then
              vim.schedule(function()
                Note.create({ title = todays_date, template = "02.0-work-daily-note.md", should_write = true })
              end)
            end
          end
        end
      end,
    })
  end,
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
        name = "notes",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes",
      },
    },
    daily_notes = {
      folder = "00-daily-notes",
      template = "00-daily-note.md",
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
    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "99-scratch-notes",
    -- Where to put new notes. Valid options are
    -- _ "current_dir" - put new notes in same directory as the current buffer.
    -- _ "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "notes_subdir",

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- If title is nil, add 4 random uppercase letters as suffix
      local suffix = title
      if suffix == nil then
        suffix = ""
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return _date_with_title(suffix)
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix(".md")
    end,

    -- Optional, customize how wiki links are formatted. You can set this to one of:
    -- _ "use_alias_only", e.g. '[[Foo Bar]]'
    -- _ "prepend*note_id", e.g. '[[foo-bar|Foo Bar]]'
    -- * "prepend*note_path", e.g. '[[foo-bar.md|Foo Bar]]'
    -- * "use_path_only", e.g. '[[foo-bar.md]]'
    -- Or you can set it to a function that takes a table of options and returns a string, like this:
    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,

    -- Optional, customize how markdown links are formatted.
    markdown_link_func = function(opts)
      return require("obsidian.util").markdown_link(opts)
    end,

    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "wiki",

    -- Optional, for templates (see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Using-templates)
    templates = {
      folder = "97-templates",
      date_format = "%Y-%m-%d",
      time_format = "%I:%M:%S %p %Z",
      -- A map for custom variables, the key should be the variable and the value a function.
      -- Functions are called with obsidian.TemplateContext objects as their sole parameter.
      -- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
        tomorrow = function()
          return os.date("%Y-%m-%d", os.time() + 86400)
        end,
        date = function()
          return os.date("%A, %B %-d, %Y")
        end,
        date_short = function()
          return os.date("%B %-d %Y")
        end,
        previous_work_date = function()
          local current_time = os.time()
          local current_day = os.date("*t", current_time).wday

          -- Calculate days to subtract to get to previous work day
          local days_to_subtract = 1 -- Default to yesterday
          if current_day == 1 then -- Sunday
            days_to_subtract = 2 -- Previous Friday
          elseif current_day == 2 then -- Monday
            days_to_subtract = 3 -- Previous Friday
          end

          return os.date("%Y-%m-%d", current_time - (days_to_subtract * 86400))
        end,
      },
      -- A map for configuring unique directories and paths for specific templates
      --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations
      customizations = {
        ["01-journal"] = {
          notes_subdir = "01-journal",
          note_id_func = function()
            return _current_date()
          end,
        },
        ["02.0-work-daily-note"] = {
          notes_subdir = "02-work/00-daily-notes",
          note_id_func = function()
            return _current_date()
          end,
        },
        ["02.1-work-meeting"] = {
          notes_subdir = "02-work/01-meetings",
          note_id_func = function(title)
            return _date_with_title(title)
          end,
        },

        ["02.2-work-note"] = {
          notes_subdir = "02-work/02-notes",
          note_id_func = function(title)
            return _date_with_title(title)
          end,
        },
      },
    },

    -- Sets how you follow URLs
    ---@param url string
    follow_url_func = function(url)
      vim.ui.open(url)
    end,

    -- Sets how you follow images
    ---@param img string
    follow_img_func = function(img)
      vim.ui.open(img)
    end,

    open = {
      ---@type boolean
      use_advanced_uri = false,
      ---@type fun(uri: string)
      func = vim.ui.open,
    },

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = "snacks.pick",
    },

    -- Optional, by default, `:ObsidianBacklinks` parses the header under
    -- the cursor. Setting to `false` will get the backlinks for the current
    -- note instead. Doesn't affect other link behaviour.
    backlinks = {
      parse_headers = true,
    },

    -- Search options
    search = {
      -- Sort search results by "path", "modified", "accessed", or "created".
      -- The recommended value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:Obsidian quick_switch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,
      -- Maximum number of lines to read from notes on disk when performing certain searches.
      max_lines = 1000,
    },

    -- Optional, determines how certain commands open notes. The valid options are:
    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - only open in a vertical split if a vsplit does not exist.
    -- 3. "hsplit" - only open in a horizontal split if a hsplit does not exist.
    -- 4. "vsplit_force" - always open a new vertical split if the file is not in the adjacent vsplit.
    -- 5. "hsplit_force" - always open a new horizontal split if the file is not in the adjacent hsplit.
    open_notes_in = "current",

    -- -- Optional, define your own callbacks to further customize behavior.
    -- callbacks = {
    --   -- Runs at the end of `require("obsidian").setup()`.
    --   ---@param _client obsidian.Client
    --   post_setup = function(_client) end,
    --
    --   -- Runs anytime you enter the buffer for a note.
    --   ---@param _client obsidian.Client
    --   ---@param _note obsidian.Note
    --   enter_note = function(_client, _note) end,
    --
    --   -- Runs anytime you leave the buffer for a note.
    --   ---@param _client obsidian.Client
    --   ---@param _note obsidian.Note
    --   leave_note = function(_client, _note) end,
    --
    --   -- Runs right before writing the buffer for a note.
    --   ---@param _client obsidian.Client
    --   ---@param _note obsidian.Note
    --   pre_write_note = function(_client, _note) end,
    --
    --   -- Runs anytime the workspace is set/changed.
    --   ---@param _workspace obsidian.Workspace
    --   post_set_workspace = function(_workspace) end,
    -- },

    -- Optional, configure additional syntax highlighting / extmarks.
    -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
    ui = {
      enable = false, -- set to false to disable all additional syntax features
      ignore_conceal_warn = false, -- set to true to disable conceallevel specific warning
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    attachments = {
      ---@type string
      img_folder = "assets/imgs",
      ---@type fun(): string
      img_name_func = function()
        return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
      end,
      ---@type boolean
      confirm_img_paste = true,
    },

    footer = {
      ---@type boolean
      enabled = true,
      ---@type string
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
      ---@type string
      hl_group = "Comment",
      ---@type string
      separator = string.rep("-", 80),
    },
    checkbox = {
      ---@type string[]
      order = { " ", "x" },
    },
  },
}
