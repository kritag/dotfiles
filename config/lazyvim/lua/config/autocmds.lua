-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(ev)
    vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = ev.buf, nowait = true })
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.g.terminal_color_0 = "#414b50"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "yaml",
--   callback = function(args)
--     local bufnr = args.buf
--     local clients = vim.lsp.get_clients({ name = "yamlls", bufnr = bufnr })
--
--     if #clients > 0 then
--       require("config.yaml_k8s_crds").init(bufnr)
--     else
--       vim.api.nvim_create_autocmd("LspAttach", {
--         once = true,
--         buffer = bufnr,
--         callback = function(lsp_args)
--           local client = vim.lsp.get_client_by_id(lsp_args.data.client_id)
--           if client and client.name == "yamlls" then
--             require("config.yaml_k8s_crds").init(bufnr)
--           end
--         end,
--       })
--     end
--   end,
-- })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
  end,
})
