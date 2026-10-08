-- Option+WASD moves between windows (and tmux panes) instead of Ctrl+hjkl.
local nav = {
  ["<M-a>"] = "TmuxNavigateLeft",
  ["<M-s>"] = "TmuxNavigateDown",
  ["<M-w>"] = "TmuxNavigateUp",
  ["<M-d>"] = "TmuxNavigateRight",
}

local keys = {}
for lhs, cmd in pairs(nav) do
  keys[#keys + 1] = { lhs, "<cmd>" .. cmd .. "<cr>", mode = "n", desc = cmd }
  keys[#keys + 1] = { lhs, "<C-\\><C-n><cmd>" .. cmd .. "<cr>", mode = "t", desc = cmd }
end

-- Snacks pickers (incl. the explorer) bind some <M-*> keys themselves; route ours to the navigator.
local picker_actions, picker_keys = {}, {}
for lhs, cmd in pairs(nav) do
  picker_actions[cmd] = function()
    vim.cmd.stopinsert()
    vim.cmd(cmd)
  end
  picker_keys[lhs] = { cmd, mode = { "n", "i" } }
end

return {
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = vim.tbl_values(nav),
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
