-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
  linebreak = true,
  pumblend = 0,
  relativenumber = true,
  showmatch = true,
  smartindent = true,
  wrap = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  extension = {
    zsh = "sh",
    sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
  },
  filename = {
    [".zshrc"] = "sh",
    [".zshenv"] = "sh",
  },
})
