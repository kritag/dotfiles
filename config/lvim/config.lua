require('settings')
require('keymaps')

lvim.plugins = {
  --  { "maxmx03/dracula.nvim" },
  { "catppuccin/nvim" },
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
