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

-- HACK: Create table of contents in neovim with markdown-toc
-- https://youtu.be/BVyrXsZ_ViA
--
-- Generate/update a Markdown TOC
-- To generate the TOC I use the markdown-toc plugin
-- https://github.com/jonschlinkert/markdown-toc
-- And the markdown-toc plugin installed as a LazyExtra
-- Function to update the Markdown TOC with customizable headings
local function update_markdown_toc(heading2, heading3)
  local path = vim.fn.expand("%") -- Expands the current file name to a full path
  local bufnr = 0 -- The current buffer number, 0 references the current active buffer
  -- Save the current view
  -- If I don't do this, my folds are lost when I run this keymap
  vim.cmd("mkview")
  -- Retrieves all lines from the current buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local toc_exists = false -- Flag to check if TOC marker exists
  local frontmatter_end = 0 -- To store the end line number of frontmatter
  -- Check for frontmatter and TOC marker
  for i, line in ipairs(lines) do
    if i == 1 and line:match("^---$") then
      -- Frontmatter start detected, now find the end
      for j = i + 1, #lines do
        if lines[j]:match("^---$") then
          frontmatter_end = j
          break
        end
      end
    end
    -- Checks for the TOC marker
    if line:match("^%s*<!%-%-%s*toc%s*%-%->%s*$") then
      toc_exists = true
      break
    end
  end
  -- Inserts H2 and H3 headings and <!-- toc --> at the appropriate position
  if not toc_exists then
    local insertion_line = 1 -- Default insertion point after first line
    if frontmatter_end > 0 then
      -- Find H1 after frontmatter
      for i = frontmatter_end + 1, #lines do
        if lines[i]:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    else
      -- Find H1 from the beginning
      for i, line in ipairs(lines) do
        if line:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    end
    -- Insert the specified headings and <!-- toc --> without blank lines
    -- Insert the TOC inside a H2 and H3 heading right below the main H1 at the top lamw25wmal
    vim.api.nvim_buf_set_lines(bufnr, insertion_line, insertion_line, false, { heading2, heading3, "<!-- toc -->" })
  end
  -- Silently save the file, in case TOC is being created for the first time
  vim.cmd("silent write")
  -- Silently run markdown-toc to update the TOC without displaying command output
  -- vim.fn.system("markdown-toc -i " .. path)
  -- I want my bulletpoints to be created only as "-" so passing that option as
  -- an argument according to the docs
  -- https://github.com/jonschlinkert/markdown-toc?tab=readme-ov-file#optionsbullets
  vim.fn.system('markdown-toc --bullets "-" -i ' .. path)
  vim.cmd("edit!") -- Reloads the file to reflect the changes made by markdown-toc
  vim.cmd("silent write") -- Silently save the file
  vim.notify("TOC updated and file saved", vim.log.levels.INFO)
  -- -- In case a cleanup is needed, leaving this old code here as a reference
  -- -- I used this code before I implemented the frontmatter check
  -- -- Moves the cursor to the top of the file
  -- vim.api.nvim_win_set_cursor(bufnr, { 1, 0 })
  -- -- Deletes leading blank lines from the top of the file
  -- while true do
  --   -- Retrieves the first line of the buffer
  --   local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
  --   -- Checks if the line is empty
  --   if line == "" then
  --     -- Deletes the line if it's empty
  --     vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, {})
  --   else
  --     -- Breaks the loop if the line is not empty, indicating content or TOC marker
  --     break
  --   end
  -- end
  -- Restore the saved view (including folds)
  vim.cmd("loadview")
end

-- HACK: Create table of contents in neovim with markdown-toc
-- https://youtu.be/BVyrXsZ_ViA
--
-- Keymap for English TOC
vim.keymap.set("n", "<leader>mt", function()
  update_markdown_toc("## Contents", "### Table of contents")
end, { desc = "[P]Insert/update Markdown TOC" })

vim.api.nvim_create_user_command("LintDiagnostics", function()
  local bufnr = 0
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    for _, d in ipairs(vim.diagnostic.get(bufnr, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })) do
      print(client.name, d.message)
    end
  end
end, {})
