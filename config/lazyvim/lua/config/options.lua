-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
  foldenable = false,
  foldexpr = "nvim_treesitter#foldexpr()", -- default is ""
  foldmethod = "expr", -- default is "normal"
  --lazyredraw = true,
  linebreak = true,
  relativenumber = true,
  showmatch = true,
  smartindent = true,
  wrap = true,
  pumblend = 0,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start({
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
