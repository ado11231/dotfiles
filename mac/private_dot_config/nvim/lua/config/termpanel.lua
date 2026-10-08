-- Right-hand terminal panel, like VS Code's: one vertical split that shows one
-- of several terminals at a time, with a winbar listing them.
local M = {}

local terms = {} -- terminal buffers, in tab order
local current = 0 -- index into terms of the one being shown
local win = nil -- the panel window
local width = nil -- last width the user left the panel at; reused when it reopens

local function win_open()
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

local function render()
  if not win_open() then
    return
  end
  local parts = {}
  for i = 1, #terms do
    parts[#parts + 1] = i == current and ("%#TabLineSel# " .. i .. " %*") or (" " .. i .. " ")
  end
  vim.wo[win].winbar = " Terminals " .. table.concat(parts)
end

local function show(i)
  current = i
  vim.api.nvim_win_set_buf(win, terms[i])
  render()
end

local function focus()
  vim.api.nvim_set_current_win(win)
  vim.cmd.startinsert()
end

local function create_win()
  vim.cmd("botright vsplit")
  win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, width or 30) -- 30 = same as the explorer
  local wo = vim.wo[win]
  wo.winfixwidth = true
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "no"
end

local function remove(buf)
  for i, b in ipairs(terms) do
    if b == buf then
      table.remove(terms, i)
      if i < current or current > #terms then
        current = current - 1
      end
      break
    end
  end
  if #terms == 0 then
    if win_open() then
      pcall(vim.api.nvim_win_close, win, true)
    end
    win = nil
  elseif win_open() then
    show(current)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end
end

function M.new()
  if not win_open() then
    create_win()
  end
  local buf = vim.api.nvim_create_buf(false, false)
  vim.bo[buf].bufhidden = "hide"
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_set_current_win(win)
  vim.fn.jobstart(vim.o.shell, {
    term = true,
    on_exit = function()
      vim.schedule(function()
        remove(buf)
      end)
    end,
  })
  terms[#terms + 1] = buf
  show(#terms)
  focus()
end

function M.open()
  if #terms == 0 then
    -- Remember manual resizes so the panel comes back at the same size.
vim.api.nvim_create_autocmd("WinResized", {
  group = group,
  callback = function()
    if win_open() and vim.tbl_contains(vim.v.event.windows, win) then
      width = vim.api.nvim_win_get_width(win)
    end
  end,
})

return M.new()
  end
  if not win_open() then
    create_win()
    show(current)
  end
  focus()
end

function M.toggle()
  if win_open() then
    vim.api.nvim_win_close(win, false)
    win = nil
  else
    M.open()
  end
end

function M.cycle(step)
  if #terms == 0 then
    -- Remember manual resizes so the panel comes back at the same size.
vim.api.nvim_create_autocmd("WinResized", {
  group = group,
  callback = function()
    if win_open() and vim.tbl_contains(vim.v.event.windows, win) then
      width = vim.api.nvim_win_get_width(win)
    end
  end,
})

return M.new()
  end
  if not win_open() then
    create_win()
  end
  show((current - 1 + step) % #terms + 1)
  focus()
end

function M.close()
  local buf = terms[current]
  if buf then
    vim.fn.jobstop(vim.bo[buf].channel) -- on_exit removes it from the panel
  end
end

local group = vim.api.nvim_create_augroup("termpanel", { clear = true })

-- Typing goes straight to the shell whenever a panel terminal gets focus.
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(ev)
    if vim.tbl_contains(terms, ev.buf) then
      vim.cmd.startinsert()
    end
  end,
})

-- Remember manual resizes so the panel comes back at the same size.
vim.api.nvim_create_autocmd("WinResized", {
  group = group,
  callback = function()
    if win_open() and vim.tbl_contains(vim.v.event.windows, win) then
      width = vim.api.nvim_win_get_width(win)
    end
  end,
})

return M
