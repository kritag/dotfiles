lvim.builtin.lualine.options.theme = "catppuccin-mocha"
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.nvimtree.setup.open_on_setup = true
lvim.builtin.terminal.active = true
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "comment",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "html",
  "ini",
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "python",
  "regex",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.which_key.setup.plugins.presets.z = true
lvim.colorscheme = "catppuccin"
lvim.format_on_save = true
lvim.line_wrap_cursor_movement = false
lvim.lint_on_save = true
lvim.transparent_window = true

local options = {
  foldenable = false,
  foldexpr = "nvim_treesitter#foldexpr()", -- default is ""
  foldmethod = "expr",                     -- default is "normal"
  lazyredraw = true,
  linebreak = true,
  relativenumber = true,
  showmatch = true,
  smartindent = true,
  wrap = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black",    filetypes = { "python" } },
  { exe = "isort",    filetypes = { "python" } },
  { exe = "prettierd" },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8" },
  { exe = "eslint_d" },
}
-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start {
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    }
  end
})
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
require("lvim.lsp.manager").setup("taplo")
vim.api.nvim_create_user_command('ShowLualineConfig', function()
  print(vim.inspect(require('lualine').get_config()))
end, {})
