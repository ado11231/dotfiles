-- Option+WASD moves between windows (and tmux panes or kitty windows) instead of Ctrl+hjkl.
local nav = {
  ["<M-a>"] = { cmd = "TmuxNavigateLeft", kitty = "left" },
  ["<M-s>"] = { cmd = "TmuxNavigateDown", kitty = "bottom" },
  ["<M-w>"] = { cmd = "TmuxNavigateUp", kitty = "top" },
  ["<M-d>"] = { cmd = "TmuxNavigateRight", kitty = "right" },
}

local in_kitty = vim.env.KITTY_LISTEN_ON and not vim.env.TMUX

-- Move inside nvim first. At the edge of nvim, move to the kitty window on that side.
local function go(to)
  local before = vim.api.nvim_get_current_win()
  vim.cmd(to.cmd)
  if in_kitty and vim.api.nvim_get_current_win() == before then
    require("config.kitty").focus(to.kitty)
  end
end

local keys = {}
for lhs, to in pairs(nav) do
  keys[#keys + 1] = { lhs, function() go(to) end, mode = "n", desc = to.cmd }
  keys[#keys + 1] = {
    lhs,
    function()
      vim.cmd.stopinsert()
      go(to)
    end,
    mode = "t",
    desc = to.cmd,
  }
end

-- Snacks pickers bind some <M-*> keys themselves; route ours to the navigator.
local picker_actions, picker_keys = {}, {}
for lhs, to in pairs(nav) do
  picker_actions[to.cmd] = function()
    vim.cmd.stopinsert()
    go(to)
  end
  picker_keys[lhs] = { to.cmd, mode = { "n", "i" } }
end

local cmds = {}
for _, to in pairs(nav) do
  cmds[#cmds + 1] = to.cmd
end

return {
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = cmds,
    keys = keys,
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = picker_actions,
        win = {
          input = { keys = picker_keys },
          list = { keys = picker_keys },
        },
      },
    },
  },
}
