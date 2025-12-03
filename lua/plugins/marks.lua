-- lua/plugins/marks.lua
-- Marks plugin that provides mark management functionality with lazy keybindings
-- Uses m{1-9} to set marks in a file and then '{1-9} to jump to them
--
-- This is the combination of some awesome work over at:
-- https://github.com/neovim/neovim/discussions/33335
--
-- I then borrowed some simplification ideas from:
-- https://github.com/LJFRIESE/nvim/blob/master/lua/config/autocmds.lua#L196-L340

-- Convert a mark number (1-9) to its corresponding character (A-I)
local function mark2char(mark)
  if mark:match("[1-9]") then
    return string.char(mark + 64)
  end
  return mark
end

-- List bookmarks in the session
local function list_marks()
  local snacks = require("snacks")
  return snacks.picker.marks({
    transform = function(item)
      -- Show numbered marks (A-I mapped to 1-9)
      if item.label and item.label:match("^[A-I]$") then
        item.label = "" .. string.byte(item.label) - string.byte("A") + 1 .. ""
        return item
      end
      -- Also show buffer-local marks (a-z)
      if item.label and item.label:match("^[a-z]$") then
        return item
      end
      return false
    end,
  })
end

-- Add Marks
local function add_mark()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  vim.cmd("mark " .. char)
  if mark:match("[1-9]") then
    vim.notify("Added mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
  else
    vim.fn.feedkeys("m" .. mark, "n")
  end
end

-- Go To Marks
local function goto_mark()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  local mark_pos = vim.api.nvim_get_mark(char, {})
  if mark_pos[1] == 0 then
    return vim.notify("No mark at " .. mark, vim.log.levels.WARN, { title = "Marks" })
  end

  vim.fn.feedkeys("'" .. mark2char(mark), "n")
end

-- Delete Marks
local function delete_mark()
  local mark = vim.fn.getcharstr()
  -- Handle numbered marks (1-9) and lowercase marks (a-z)
  if mark:match("[1-9]") then
    vim.api.nvim_del_mark(mark2char(mark))
    vim.notify("Deleted mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
  elseif mark:match("[a-z]") then
    vim.cmd("delmark " .. mark)
    vim.notify("Deleted mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
  else
    vim.notify("Invalid mark: " .. mark, vim.log.levels.WARN, { title = "Marks" })
  end
end

local function delete_all_marks()
  vim.cmd("delmarks A-I")
  vim.cmd("delmarks a-z")
  vim.notify("Deleted all marks", vim.log.levels.INFO, { title = "Marks" })
end

return {
  {
    "which-key.nvim",
    keys = {
      {
        "m",
        add_mark,
        desc = "Add mark",
      },
      {
        "'",
        goto_mark,
        desc = "Go to mark",
      },
      {
        "<Leader>mm",
        list_marks,
        desc = "List marks",
      },
      {
        "<Leader>md",
        delete_mark,
        desc = "Delete mark",
      },
      {
        "<Leader>mD",
        delete_all_marks,
        desc = "Delete all marks",
      },
    },
  },
}
