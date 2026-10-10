-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Programs in a terminal (like Codex) ask for the background and text colours to
-- style themselves. Neovim always answers black and white, which gives Codex a
-- black box on Nord. Answer with the colours of the current colorscheme instead.
for _, au in ipairs(vim.api.nvim_get_autocmds({ group = "nvim.terminal", event = "TermRequest" })) do
  if au.desc == "Handles OSC foreground/background color requests" then
    vim.api.nvim_del_autocmd(au.id)
  end
end

vim.api.nvim_create_autocmd("TermRequest", {
  group = vim.api.nvim_create_augroup("terminal_colors", { clear = true }),
  callback = function(ev)
    local code = ev.data.sequence:match("^\27%](1[01]);%?$") -- 10 = text colour, 11 = background
    local channel = vim.bo[ev.buf].channel
    if not code or channel == 0 then
      return
    end
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    local color = code == "10" and (normal.fg or 0xffffff) or (normal.bg or 0x000000)
    local r, g, b = bit.rshift(color, 16), bit.band(bit.rshift(color, 8), 0xff), bit.band(color, 0xff)
    local reply = string.format("\27]%s;rgb:%04x/%04x/%04x%s", code, r * 257, g * 257, b * 257, ev.data.terminator)
    vim.api.nvim_chan_send(channel, reply)
  end,
})

-- VS Code-style layout on start: editor (or the dashboard) on the left, terminals right.
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
  if vim.env.KITTY_LISTEN_ON and not vim.env.TMUX then
    require("config.kitty").open({ keep_focus = true })
    return
  end
  local main = vim.api.nvim_get_current_win()
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
