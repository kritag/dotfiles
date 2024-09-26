require('settings')
require('keymaps')

lvim.plugins = {
  { "catppuccin/nvim" },
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
