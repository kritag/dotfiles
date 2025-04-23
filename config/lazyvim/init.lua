-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.schedule(function()
  vim.notify("Current terminal_color_0: " .. tostring(vim.g.terminal_color_0))
end)
