local utils = {
  "marks",
}

for _, util in ipairs(utils) do
  local ok, err = pcall(require, "util." .. util)
  if not ok then
    vim.notify("Failed to load util." .. util .. ": " .. tostring(err), vim.log.levels.WARN)
  end
end
