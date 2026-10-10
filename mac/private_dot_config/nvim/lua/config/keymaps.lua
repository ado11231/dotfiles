-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Right-hand terminals: real kitty windows when in kitty (lua/config/kitty.lua),
-- otherwise the nvim terminal panel (lua/config/termpanel.lua).
local in_kitty = vim.env.KITTY_LISTEN_ON and not vim.env.TMUX
local term = require(in_kitty and "config.kitty" or "config.termpanel")
local modes = { "n", "t" }
vim.keymap.set(modes, "<M-t>", term.new, { desc = "New terminal" })
vim.keymap.set(modes, "<M-Up>", function() term.cycle(-1) end, { desc = "Previous terminal" })
vim.keymap.set(modes, "<M-Down>", function() term.cycle(1) end, { desc = "Next terminal" })
vim.keymap.set(modes, "<M-x>", term.close, { desc = "Close terminal" })
vim.keymap.set(modes, "<M-`>", term.toggle, { desc = "Toggle terminal panel" })
