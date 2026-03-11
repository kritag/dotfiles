-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
  -- pumblend = 0,
  showmatch = true,
  wrap = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Ensure Neovim writes its own log under XDG state, not project/dotfiles dirs.
vim.env.NVIM_LOG_FILE = vim.fn.stdpath("state") .. "/nvim.log"

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  extension = {
    zsh = "sh",
    sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
    rasi = "rasi",
  },
  filename = {
    [".zshrc"] = "sh",
    [".zshenv"] = "sh",
  },
})
