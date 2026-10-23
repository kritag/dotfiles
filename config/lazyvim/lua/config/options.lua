-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- gh emits ANSI colors under CLICOLOR_FORCE, which breaks snacks.gh JSON parsing
vim.env.CLICOLOR_FORCE = nil

local options = {
  -- pumblend = 0,
  showmatch = true,
  wrap = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Over SSH, `y` copies to the local clipboard through OSC 52. Paste reads the unnamed register,
-- because the OSC 52 read query makes kitty ask for permission on every `p`.
if vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
  vim.opt.clipboard = "unnamedplus"
end
