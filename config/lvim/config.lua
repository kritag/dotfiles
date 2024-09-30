require('settings')
require('keymaps')

lvim.plugins = {
  {
    "catppuccin/nvim",
    name = "catppuccin"
  },
  { "norcalli/nvim-colorizer.lua" },
}

lvim.autocommands = {
  {
    "VimLeave",
    {
      pattern = "*",
      command = "set guicursor= | call chansend(v:stderr, \"\x1b[ q\")"
    }
  }
}
require 'colorizer'.setup()
vim.api.nvim_create_user_command('ShowLualineConfig', function()
  print(vim.inspect(require('lualine').get_config()))
end, {})
