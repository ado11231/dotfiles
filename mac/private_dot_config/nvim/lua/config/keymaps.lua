-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Right-hand terminal panel (see lua/config/termpanel.lua)
local term = require("config.termpanel")
local modes = { "n", "t" }
vim.keymap.set(modes, "<M-t>", term.new, { desc = "New terminal" })
vim.keymap.set(modes, "<M-Up>", function() term.cycle(-1) end, { desc = "Previous terminal" })
vim.keymap.set(modes, "<M-Down>", function() term.cycle(1) end, { desc = "Next terminal" })
vim.keymap.set(modes, "<M-x>", term.close, { desc = "Close terminal" })
vim.keymap.set(modes, "<M-`>", term.toggle, { desc = "Toggle terminal panel" })
