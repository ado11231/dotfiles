-- Right-hand terminals as real kitty windows instead of nvim terminals.
-- Used when nvim runs inside kitty with remote control on (see kitty.conf).
-- Same functions as config.termpanel, so the keymaps work with either one.
local M = {}

local self_id = tonumber(vim.env.KITTY_WINDOW_ID)

-- Run `kitty @ <args>` and return its output, or nil if it failed.
local function kitty(args)
  local result = vim.system(vim.list_extend({ "kitty", "@" }, args), { text = true }):wait()
  if result.code ~= 0 then
    vim.notify("kitty @ " .. table.concat(args, " ") .. "\n" .. (result.stderr or ""), vim.log.levels.WARN)
    return nil
  end
  return result.stdout
end

-- Ids of the other kitty windows in nvim's tab: the right-hand terminals.
local function panel()
  local out = kitty({ "ls" })
  if not out then
    return {}
  end
  for _, os_win in ipairs(vim.json.decode(out)) do
    for _, tab in ipairs(os_win.tabs) do
      local ids, mine = {}, false
      for _, w in ipairs(tab.windows) do
        if w.id == self_id then
          mine = true
        else
          ids[#ids + 1] = w.id
        end
      end
      if mine then
        return ids
      end
    end
  end
  return {}
end

-- The first terminal goes to the right of nvim, the next ones stack under it.
function M.new(opts)
  opts = opts or {}
  local ids = panel()
  local args = { "launch", "--type=window", "--cwd=" .. vim.fn.getcwd() }
  if #ids == 0 then
    -- kitty takes a percentage, so turn 30 columns (the old panel width) into one.
    local bias = math.ceil(30 / vim.o.columns * 100)
    vim.list_extend(args, { "--location=vsplit", "--bias=" .. bias })
  else
    vim.list_extend(args, { "--location=hsplit", "--next-to=id:" .. ids[#ids] })
  end
  if opts.keep_focus then
    args[#args + 1] = "--keep-focus"
  end
  kitty(args)
end

-- Open the terminals if there are none, otherwise jump to them.
function M.open(opts)
  opts = opts or {}
  local ids = panel()
  if #ids == 0 then
    M.new(opts)
  elseif not opts.keep_focus then
    kitty({ "focus-window", "--match=id:" .. ids[1] })
  end
end

-- kitty can't hide a window, so this makes nvim fill the whole kitty window
-- (the stack layout) and back again.
function M.toggle()
  if #panel() == 0 then
    M.new()
  else
    kitty({ "action", "toggle_layout", "stack" })
  end
end

-- From nvim, Alt+Up/Down jumps to the terminals. Inside them kitty handles it.
function M.cycle(step)
  local ids = panel()
  if #ids == 0 then
    return M.new()
  end
  kitty({ "focus-window", "--match=id:" .. (step < 0 and ids[#ids] or ids[1]) })
end

-- Close the terminal you were last in.
function M.close()
  local ids = panel()
  if #ids > 0 then
    kitty({ "close-window", "--match=recent:1 and not id:" .. self_id })
  end
end

-- Move to the kitty window next to nvim. dir is left, right, top or bottom.
function M.focus(dir)
  kitty({ "focus-window", "--match=neighbor:" .. dir })
end

-- Tell kitty when nvim is focused, so the Alt keys in kitty.conf pass through to nvim.
local function set_in_editor(on)
  vim.api.nvim_ui_send("\27]1337;SetUserVar=in_editor" .. (on and "=MQ==" or "") .. "\7")
end

local group = vim.api.nvim_create_augroup("kitty_in_editor", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
  group = group,
  callback = function()
    set_in_editor(true)
  end,
})
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = group,
  callback = function()
    set_in_editor(false)
  end,
})
-- keymaps.lua loads after startup, so set it now too.
if vim.v.vim_did_enter == 1 then
  set_in_editor(true)
end

return M
