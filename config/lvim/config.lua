require('settings')
require('keymaps')

lvim.plugins = {
  { "maxmx03/dracula.nvim" },
}
vim.opt.linebreak = true
vim.opt.relativenumber = true
vim.opt.lazyredraw = true

local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "flake8", filetypes = { "python" } } }

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup{{ name="black"}, }

lvim.keys.normal_mode["0"] = "^" -- Remap VIM 0 to first non-blank characte
lvim.keys.normal_mode["<leader><cr>"] = ":noh<cr>" -- Remap <leader>+Enter to clear search highlight
lvim.keys.normal_mode["<space>"] = "/" -- Remap space to search
