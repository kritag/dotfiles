-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "0", "^", { desc = "VIM 0 to first non-blank character" })
vim.keymap.set("n", "<leader><cr>", ":noh<cr>", { desc = "<leader>+Enter to clear search highlight" })
vim.keymap.set("n", "x", '"_x', { desc = "Don't yank on x" })
vim.keymap.set("n", "D", '"_D', { desc = "Don't yank on D" })
vim.keymap.set("n", "C", '"_C', { desc = "Don't yank on C" })
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Cycle buffers right" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Cycle buffers left" })
-- floating terminal
local lazyterm = function()
  LazyVim.terminal(nil, { cwd = LazyVim.root() })
end
vim.keymap.set("n", "<c-\\>", lazyterm, { desc = "Terminal (Root Dir)" })
vim.keymap.set("t", "<c-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- Remove default keymaps for navigating windows
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")

-- Move to window using the <ctrl> arrow keys
vim.keymap.set("n", "<C-h>", "<cmd>vertical resize -2<cr>", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<cmd>resize -2<cr>", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<cmd>resize +2<cr>", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<cmd>vertical resize +2<cr>", { desc = "Go to Right Window", remap = true })
-- Resize window using <ctrl> hjkl keys
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Go to Right Window" })

-- Kubectl
vim.keymap.set("n", "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })
