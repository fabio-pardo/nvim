-- Options are automatically loaded before lazy.nvim startup
-- Migrated from LazyVim defaults + custom additions

--------------------------------------------------------------------------------
-- Leader Keys
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--------------------------------------------------------------------------------
-- Global Flags
--------------------------------------------------------------------------------
vim.g.autoformat = true -- Enable auto format on save
vim.g.snacks_animate = true -- Enable snacks animations
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

--------------------------------------------------------------------------------
-- UI Options
--------------------------------------------------------------------------------
local opt = vim.opt

opt.termguicolors = true -- True colour support
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Highlight current line
opt.signcolumn = "yes" -- Always show signcolumn
opt.showmode = false -- Don't show mode (statusline handles it)
opt.ruler = false -- Disable default ruler
opt.laststatus = 3 -- Global statusline
opt.cmdheight = 0 -- Hide command line when not in use
opt.pumheight = 10 -- Max popup menu height
opt.pumblend = 10 -- Popup menu transparency

opt.conceallevel = 2 -- Hide markup for bold/italic
opt.list = true -- Show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = {
  diff = "╱",
  eob = " ",
}

--------------------------------------------------------------------------------
-- Editor Behaviour
--------------------------------------------------------------------------------
opt.mouse = "a" -- Enable mouse in all modes
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- System clipboard (unless SSH)
opt.confirm = true -- Confirm before closing unsaved buffers
opt.autowrite = true -- Auto save before commands like :next
opt.autoread = true -- Auto reload files changed outside vim

opt.scrolloff = 4 -- Lines of context above/below cursor
opt.sidescrolloff = 8 -- Columns of context
opt.wrap = true -- Enable line wrap (personal preference)
opt.linebreak = true -- Wrap at word boundaries
opt.breakindent = true -- Indent wrapped lines
opt.smoothscroll = true -- Smooth scrolling

opt.virtualedit = "block" -- Allow cursor beyond text in visual block

--------------------------------------------------------------------------------
-- Search
--------------------------------------------------------------------------------
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Unless uppercase used
opt.incsearch = true -- Incremental search
opt.hlsearch = true -- Highlight matches
opt.inccommand = "nosplit" -- Live preview of substitutions
opt.grepprg = "rg --vimgrep" -- Use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m"

--------------------------------------------------------------------------------
-- Indentation
--------------------------------------------------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Indent width
opt.softtabstop = 0 -- Use tabstop value
opt.smartindent = true -- Smart auto-indenting
opt.autoindent = true -- Copy indent from current line
opt.shiftround = true -- Round indent to shiftwidth

--------------------------------------------------------------------------------
-- Folding
--------------------------------------------------------------------------------
opt.foldlevel = 99 -- Start with all folds open
opt.foldmethod = "indent" -- Fold based on indentation
opt.foldtext = "" -- Use default fold text

--------------------------------------------------------------------------------
-- Splits
--------------------------------------------------------------------------------
opt.splitbelow = true -- Horizontal splits below
opt.splitright = true -- Vertical splits to the right
opt.splitkeep = "screen" -- Keep text on screen when splitting
opt.winminwidth = 5 -- Minimum window width

--------------------------------------------------------------------------------
-- Completion
--------------------------------------------------------------------------------
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wildignorecase = false -- Case sensitive file completion

--------------------------------------------------------------------------------
-- Performance
--------------------------------------------------------------------------------
opt.updatetime = 200 -- Faster CursorHold
opt.timeoutlen = 300 -- Faster which-key popup
opt.redrawtime = 2000 -- Max time for syntax highlighting
opt.lazyredraw = false -- Don't redraw during macros (disabled for noice.nvim)

--------------------------------------------------------------------------------
-- Files & Backup
--------------------------------------------------------------------------------
opt.backup = false -- No backup files
opt.writebackup = true -- Backup before overwriting
opt.swapfile = false -- No swap files
opt.undofile = true -- Persistent undo
opt.undolevels = 10000 -- Maximum undo levels
opt.hidden = true -- Allow hidden buffers

--------------------------------------------------------------------------------
-- Sessions (AutoSession)
--------------------------------------------------------------------------------
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

--------------------------------------------------------------------------------
-- Misc
--------------------------------------------------------------------------------
opt.jumpoptions = "view" -- Restore view when jumping
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- Reduce messages
opt.spelllang = { "en" }
opt.spelloptions = "noplainbuffer"
opt.formatoptions = "jcroqlnt" -- Format options
