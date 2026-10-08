-- Keep the explorer sidebar narrow and plain: no search box until you press /,
-- no tree guide lines, one folder icon for every folder, file icons in one muted colour.
local function format(item, picker)
  local F = Snacks.picker.format
  local ret = {}
  if item.parent then
    vim.list_extend(ret, F.tree(item, picker))
  end
  if item.status then
    vim.list_extend(ret, F.file_git_status(item, picker))
  end
  if item.severity then
    vim.list_extend(ret, F.severity(item, picker))
  end
  local icon, hl
  if item.dir then
    icon, hl = item.open and "󰝰" or "󰉋", "Directory"
  else
    icon, hl = Snacks.util.icon(item.file, "file"), "Comment"
  end
  ret[#ret + 1] = { Snacks.picker.util.align(vim.trim(icon) .. " ", 2), hl, virtual = true }
  vim.list_extend(ret, F.filename(item, picker)) -- icons.files.enabled = false, so no second icon
  return ret
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = { layout = { width = 30, min_width = 30 }, hidden = { "input" } },
            format = format,
            icons = {
              files = { enabled = false },
              tree = { vertical = "  ", middle = "  ", last = "  " },
            },
          },
        },
      },
    },
  },
}
