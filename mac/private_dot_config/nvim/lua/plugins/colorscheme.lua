-- Nord by default, TokyoNight available. Pick with <leader>uC; the choice is
-- saved to stdpath("state")/colorscheme and restored on the next start.
local file = vim.fn.stdpath("state") .. "/colorscheme"

local function saved()
  local f = io.open(file, "r")
  if not f then
    return "nord"
  end
  local name = f:read("*l")
  f:close()
  return (name and name ~= "") and name or "nord"
end

return {
  { "gbprod/nord.nvim", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        if not pcall(vim.cmd.colorscheme, saved()) then
          vim.cmd.colorscheme("nord")
        end
        vim.api.nvim_create_autocmd("ColorScheme", {
          group = vim.api.nvim_create_augroup("save_colorscheme", { clear = true }),
          callback = function(ev)
            local f = io.open(file, "w")
            if f then
              f:write(ev.match)
              f:close()
            end
          end,
        })
      end,
    },
  },
}
