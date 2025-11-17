local prefix = "<leader>o"

-- Helper function to get current date
---@return string
local _current_date = function()
  return os.date("%Y-%m-%d")
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
                "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/02-work/00-work-daily-notes/"
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
    { prefix .. "o", "<cmd>ObsidianOpen<CR>", desc = "Open on App" },
    { prefix .. "g", "<cmd>ObsidianSearch<CR>", desc = "Grep" },
    { prefix .. "n", "<cmd>ObsidianNew<CR>", desc = "New Note" },
    { prefix .. "N", "<cmd>ObsidianNewFromTemplate<CR>", desc = "New Note (Template)" },
    { prefix .. "<space>", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Files" },
    { prefix .. "b", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
    { prefix .. "t", "<cmd>ObsidianTags<CR>", desc = "Tags" },
    { prefix .. "T", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
    { prefix .. "L", "<cmd>ObsidianLink<CR>", mode = "v", desc = "Link" },
    { prefix .. "l", "<cmd>ObsidianLinks<CR>", desc = "Links" },
    { prefix .. "k", "<cmd>ObsidianLinkNew<CR>", mode = "v", desc = "New Link" }, -- Fixed: changed from 'l' to 'k'
    { prefix .. "e", "<cmd>ObsidianExtractNote<CR>", mode = "v", desc = "Extract Note" },
    { prefix .. "w", "<cmd>ObsidianWorkspace<CR>", desc = "Workspace" },
    { prefix .. "r", "<cmd>ObsidianRename<CR>", desc = "Rename" },
    { prefix .. "i", "<cmd>ObsidianPasteImg<CR>", desc = "Paste Image" },
    { prefix .. "d", "<cmd>ObsidianDailies<CR>", desc = "Daily Notes" },
  },
  opts = {
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
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
      -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
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
          notes_subdir = "02-work/00-work-daily-notes",
          note_id_func = function()
            return _current_date()
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

    ---@class obsidian.config.OpenOpts
    ---
    ---Opens the file with current line number
    ---@field use_advanced_uri? boolean
    ---
    ---Function to do the opening, default to vim.ui.open
    ---@field func? fun(uri: string)
    open = {
      use_advanced_uri = false,
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

    -- Optional, sort search results by "path", "modified", "accessed", or "created".
    -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
    -- that `:Obsidian quick_switch` will show the notes sorted by latest modified time
    sort_by = "modified",
    sort_reversed = true,

    -- Set the maximum number of lines to read from notes on disk when performing certain searches.
    search_max_lines = 1000,

    -- Optional, determines how certain commands open notes. The valid options are:
    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - only open in a vertical split if a vsplit does not exist.
    -- 3. "hsplit" - only open in a horizontal split if a hsplit does not exist.
    -- 4. "vsplit_force" - always open a new vertical split if the file is not in the adjacent vsplit.
    -- 5. "hsplit_force" - always open a new horizontal split if the file is not in the adjacent hsplit.
    open_notes_in = "current",

    -- Optional, define your own callbacks to further customize behavior.
    callbacks = {
      -- Runs at the end of `require("obsidian").setup()`.
      ---@param client obsidian.Client
      post_setup = function(client) end,

      -- Runs anytime you enter the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      enter_note = function(client, note) end,

      -- Runs anytime you leave the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      leave_note = function(client, note) end,

      -- Runs right before writing the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      pre_write_note = function(client, note) end,

      -- Runs anytime the workspace is set/changed.
      ---@param workspace obsidian.Workspace
      post_set_workspace = function(workspace) end,
    },

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

    ---@class obsidian.config.AttachmentsOpts
    ---
    ---Default folder to save images to, relative to the vault root.
    ---@field img_folder? string
    ---
    ---Default name for pasted images
    ---@field img_name_func? fun(): string
    ---
    ---Default text to insert for pasted images, for customizing, see: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images
    ---@field img_text_func? fun(path: obsidian.Path): string
    ---
    ---Whether to confirm the paste or not. Defaults to true.
    ---@field confirm_img_paste? boolean
    attachments = {
      img_folder = "assets/imgs",
      img_name_func = function()
        return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
      end,
      confirm_img_paste = true,
    },

    ---@deprecated in favor of the footer option below
    statusline = {
      enabled = true,
      format = "{{properties}} properties {{backlinks}} backlinks {{words}} words {{chars}} chars",
    },

    ---@class obsidian.config.FooterOpts
    ---
    ---@field enabled? boolean
    ---@field format? string
    ---@field hl_group? string
    ---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
    footer = {
      enabled = true,
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
      hl_group = "Comment",
      separator = string.rep("-", 80),
    },
    ---@class obsidian.config.CheckboxOpts
    ---
    ---Order of checkbox state chars, e.g. { " ", "x" }
    ---@field order? string[]
    checkbox = {
      order = { " ", "x" },
    },
  },
}
