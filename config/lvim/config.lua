-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.colorscheme = "dracula"

lvim.plugins = {
  { "maxmx03/dracula.nvim" },
}
vim.opt.linebreak = true
vim.opt.relativenumber = true
vim.opt.lazyredraw = true
lvim.leader = ","
lvim.builtin.lualine.options.theme = "dracula"
lvim.builtin.lualine.sections.lualine_a = { "mode" }

local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "flake8", filetypes = { "python" } } }

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup{{ name="black"}, }

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "json",
  "yaml",
  "lua",
  "python",
}

lvim.keys.normal_mode["0"] = "^" -- Remap VIM 0 to first non-blank characte
lvim.keys.normal_mode["<leader><cr>"] = ":noh<cr>" -- Remap VIM 0 to first non-blank characte
lvim.keys.normal_mode["<space>"] = "/" -- Remap VIM 0 to first non-blank characte
-- Set default syntax for all files
vim.api.nvim_create_autocmd({"BufNewFile" ,"BufRead"}, {
  pattern = {"*"},
  command = "if &ft == '' | set ft=zsh | endif",
})
