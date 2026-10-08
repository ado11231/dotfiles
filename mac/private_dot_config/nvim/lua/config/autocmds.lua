-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- VS Code-style layout on start: explorer left, editor middle, terminals right.
-- Skipped when nvim is used as a quick editor (git commits, temp files from other tools).
local function wants_layout()
  if vim.tbl_contains(vim.v.argv, "--headless") or vim.bo.filetype:match("^git") then
    return false
  end
  for _, arg in ipairs(vim.fn.argv()) do
    local path = vim.fn.fnamemodify(arg, ":p")
    if path:find("/%.git/") or path:find("^/tmp/") or path:find("^/private/") or path:find("^/var/folders/") then
      return false
    end
  end
  return true
end

local function open_layout()
  if not wants_layout() then
    return
  end
  local main = vim.api.nvim_get_current_win()
  if #Snacks.picker.get({ source = "explorer" }) == 0 then
    Snacks.explorer()
  end
  require("config.termpanel").open()
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(main) then
      vim.api.nvim_set_current_win(main)
      vim.cmd.stopinsert()
    end
  end, 100)
end

-- With file arguments LazyVim loads this file before VimEnter, so wait for it.
if vim.v.vim_did_enter == 1 then
  open_layout()
else
  vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = vim.schedule_wrap(open_layout) })
end
