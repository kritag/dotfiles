-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "0", "^", { desc = "VIM 0 to first non-blank character" })
vim.keymap.set("n", "<leader><cr>", ":noh<cr>", { desc = "<leader>+Enter to clear search highlight" })
vim.keymap.set("n", "x", '"_x', { desc = "Don't yank on x" })
vim.keymap.set("n", "D", '"_D', { desc = "Don't yank on D" })
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Cycle buffers right" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Cycle buffers left" })
