-- Keymaps are automatically loaded on the VeryLazy event
-- Migrated from LazyVim defaults + custom additions

local map = vim.keymap.set

--------------------------------------------------------------------------------
-- Better Movement
--------------------------------------------------------------------------------
-- Better up/down (respects wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

--------------------------------------------------------------------------------
-- Window Resize
--------------------------------------------------------------------------------
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

--------------------------------------------------------------------------------
-- Move Lines
--------------------------------------------------------------------------------
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

--------------------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------------------
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

--------------------------------------------------------------------------------
-- Clear Search / Escape
--------------------------------------------------------------------------------
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

--------------------------------------------------------------------------------
-- Search Navigation (saner n/N behaviour)
--------------------------------------------------------------------------------
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

--------------------------------------------------------------------------------
-- Undo Break-points
--------------------------------------------------------------------------------
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

--------------------------------------------------------------------------------
-- Save
--------------------------------------------------------------------------------
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--------------------------------------------------------------------------------
-- Keywordprg
--------------------------------------------------------------------------------
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

--------------------------------------------------------------------------------
-- Better Indenting
--------------------------------------------------------------------------------
map("x", "<", "<gv")
map("x", ">", ">gv")

--------------------------------------------------------------------------------
-- Commenting
--------------------------------------------------------------------------------
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

--------------------------------------------------------------------------------
-- Lazy
--------------------------------------------------------------------------------
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

--------------------------------------------------------------------------------
-- New File
--------------------------------------------------------------------------------
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

--------------------------------------------------------------------------------
-- Location & Quickfix Lists
--------------------------------------------------------------------------------
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

--------------------------------------------------------------------------------
-- Diagnostics
--------------------------------------------------------------------------------
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

--------------------------------------------------------------------------------
-- Quit
--------------------------------------------------------------------------------
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

--------------------------------------------------------------------------------
-- Inspect
--------------------------------------------------------------------------------
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })

--------------------------------------------------------------------------------
-- Terminal
--------------------------------------------------------------------------------
map("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })
map("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd() })
end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<c-/>", function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd() })
end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<c-_>", function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd() })
end, { desc = "which_key_ignore" })

--------------------------------------------------------------------------------
-- Windows
--------------------------------------------------------------------------------
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

--------------------------------------------------------------------------------
-- Tabs
--------------------------------------------------------------------------------
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

--------------------------------------------------------------------------------
-- Which-Key Groups & Custom Keymaps
--------------------------------------------------------------------------------
local wk = require("which-key")
wk.add({
  -- General groups
  { "<leader>o", group = "Obsidian", icon = { icon = "🔮", hl = "" } },
  { "<leader>a", group = "AI Code Companion", icon = { icon = "🤖", hl = "" } },
  { "<leader>b", group = "Buffer", icon = { icon = "󰈔", hl = "" } },
  { "<leader>c", group = "Code", icon = { icon = "👨‍💻", hl = "" } },
  { "<leader>d", group = "Debug", icon = { icon = "🪲", hl = "" } },
  { "<leader>f", group = "File/Find", icon = { icon = "🔍", hl = "" } },
  { "<leader>g", group = "Git", icon = { icon = "󰊢 ", hl = "" } },
  { "<leader>q", group = "Quit/Session", icon = { icon = "💾", hl = "" } },
  { "<leader>s", group = "Search", icon = { icon = "🔍", hl = "" } },
  { "<leader>u", group = "UI", icon = { icon = "󰙵 ", hl = "" } },
  { "<leader>w", group = "Windows", icon = { icon = "🪟", hl = "" } },
  { "<leader>x", group = "Diagnostics/Quickfix", icon = { icon = "󱖫 ", hl = "" } },
  { "<leader><tab>", group = "Tabs", icon = { icon = "󰓩 ", hl = "" } },
  { "<leader>m", group = "Marks", icon = { icon = "📍", hl = "" } },
})
