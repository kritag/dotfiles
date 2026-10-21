local L, R = "", "" -- rounded left / right caps

local function tools()
  local buf = vim.api.nvim_get_current_buf()
  local names = vim
    .iter(vim.lsp.get_clients({ bufnr = buf }))
    :map(function(c)
      return c.name
    end)
    :totable()

  local ok_lint, lint = pcall(require, "lint")
  if ok_lint then
    local ctx = { filename = vim.api.nvim_buf_get_name(buf) }
    for _, name in ipairs(lint._resolve_linter_by_ft(vim.bo[buf].filetype)) do
      local linter = lint.linters[name]
      local cond = type(linter) == "table" and linter.condition
      if linter and (not cond or cond(ctx)) then
        names[#names + 1] = name
      end
    end
  end

  local ok_conform, conform = pcall(require, "conform")
  if ok_conform then
    for _, f in ipairs((conform.list_formatters_to_run(buf))) do
      names[#names + 1] = f.name
    end
  end

  local unique = {}
  for _, name in ipairs(names) do
    if name ~= "null-ls" and not vim.list_contains(unique, name) then
      unique[#unique + 1] = name
    end
  end

  return #unique > 0 and table.concat(unique, ", ") or "No servers"
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local default = opts.sections
    ---@diagnostic disable-next-line: assign-type-mismatch -- LazyVim types cwd as `false`
    local root = LazyVim.lualine.root_dir({ cwd = true })
    local diagnostics = default.lualine_c[2]
    local diff = default.lualine_x[#default.lualine_x]

    local schema = {
      function()
        return require("k8s-yaml-schemas.select").status()
      end,
      icon = "",
      cond = function()
        return vim.bo.filetype == "yaml" and vim.b.yaml_schema ~= nil
      end,
    }

    opts.options = vim.tbl_deep_extend("force", opts.options, {
      section_separators = "",
      component_separators = "",
      disabled_filetypes = {
        winbar = vim.list_extend({ "neo-tree" }, opts.options.disabled_filetypes.statusline),
      },
    })

    opts.sections = vim.tbl_extend("force", default, {
      lualine_a = { { "mode", separator = { left = L, right = R } } },
      lualine_b = {
        "branch",
        diff,
        {
          function()
            return R
          end,
          cond = function()
            return vim.b.gitsigns_head ~= nil
          end,
          color = function()
            return {
              fg = Snacks.util.color("lualine_b_normal", "bg"),
              bg = Snacks.util.color("lualine_c_normal", "bg"),
            }
          end,
          padding = 0,
          separator = "",
        },
      },
      -- a second `%=` (lualine already puts one before section x) centers the schema between left and right
      lualine_c = {
        root,
        diagnostics,
        {
          function()
            return "%="
          end,
          cond = schema.cond,
        },
        schema,
      },
      lualine_x = vim.list_slice(default.lualine_x, 1, #default.lualine_x - 1),
      lualine_y = {
        { "progress", separator = { left = L }, padding = { left = 1, right = 0 } },
        { "location", padding = { left = 1, right = 1 } },
      },
      lualine_z = {
        {
          function()
            local ok, names = pcall(tools)
            return ok and names or "tools: error"
          end,
          separator = { left = L, right = R },
        },
      },
    })

    opts.winbar = {
      lualine_b = {
        { "filetype", icon_only = true, separator = { left = L }, padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path(), separator = { right = R } },
      },
    }

    -- function/symbol breadcrumbs
    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local symbols = require("trouble").statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "WinBar",
      })
      opts.winbar.lualine_c = {
        {
          symbols.get,
          color = { bg = "None" },
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        },
      }
    end
  end,
}
