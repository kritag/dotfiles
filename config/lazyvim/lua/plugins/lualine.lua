local colors = require("catppuccin.palettes").get_palette()

local function getLspName()
  local buf_clients = vim.lsp.get_clients()
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return "  No servers"
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  local ok, conform = pcall(require, "conform")
  local formatters = table.concat(conform.formatters_by_ft[vim.bo.filetype], " ")
  if ok then
    for formatter in formatters:gmatch("%w+") do
      if formatter then
        table.insert(buf_client_names, formatter)
      end
    end
  end

  local hash = {}
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end
  local language_servers = table.concat(unique_client_names, ", ")

  return "" .. language_servers
end

local lsp = {
  function()
    return getLspName()
  end,
  separator = { left = "", right = "" },
  color = { bg = colors.mauve, fg = colors.surface0, gui = "bold" },
}
local space = {
  function()
    return " "
  end,
}
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "catppuccin",
          globalstatus = vim.o.laststatus == 3,
          section_separators = "",
          --{ left = "", right = "" },
          component_separators = "",
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              separator = { left = "", right = "" },
            },
          },
          lualine_b = { space },
          lualine_c = {
            {
              "branch",
              color = { bg = colors.green, fg = colors.surface0, gui = "bold" },
              separator = { left = "", right = "" },
            },
            {
              "diff",
              color = { bg = colors.surface0, fg = colors.blue, gui = "bold" },
              separator = { right = "" },
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },

            {
              function()
                return " "
              end,
              color = { bg = colors.transparent_bg, fg = colors.blue },
            },
            {
              function()
                local component = LazyVim.lualine.root_dir() -- Retrieve the component
                return component[1]() -- Execute the function part of the component
              end,
              separator = { left = "", right = "" }, -- Apply separators
              color = { fg = colors.crust, bg = colors.pink, gui = "bold" },
            },
            {
              "diagnostics",
              color = { bg = colors.surface0, fg = colors.blue, gui = "bold" },
              separator = { right = "" },
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              diagnostics_color = {
                error = { fg = colors.red },
                warn = { fg = colors.orange },
                info = { fg = colors.sky },
                hint = { fg = colors.teal },
              },
            },
          },
          lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return LazyVim.ui.fg("Statement") end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return LazyVim.ui.fg("Constant") end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return LazyVim.ui.fg("Debug") end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return LazyVim.ui.fg("Special") end,
          },
          },
          lualine_y = {
            {
              "progress",
              separator = { left = "", right = "" },
              padding = { left = 1, right = 1 },
              color = { bg = colors.surface0, fg = colors.blue, gui = "bold" },
            },
            {
              "location",
              padding = { left = 1, right = 1 },
              color = { bg = colors.surface0, fg = colors.blue, gui = "bold" },
            },
          },
          lualine_z = {
            {
              "lsp",
            },
          },
        },
        winbar = {
          lualine_c = {
            { "filetype", icon_only = true, cond = nil, separator = "", padding = { left = 0, right = 0 } },
            { LazyVim.lualine.pretty_path() },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
      local custom_catppuccin = require("lualine.themes.catppuccin")
      -- Set pink background for all available modes
      custom_catppuccin.normal.b.bg = colors.transparent_bg
      custom_catppuccin.insert.b.bg = colors.transparent_bg
      custom_catppuccin.terminal.b.bg = colors.transparent_bg
      custom_catppuccin.replace.b.bg = colors.transparent_bg
      custom_catppuccin.command.b.bg = colors.transparent_bg
      custom_catppuccin.inactive.b.bg = colors.transparent_bg
      custom_catppuccin.visual.b.bg = colors.transparent_bg
      custom_catppuccin.inactive.b.bg = colors.transparent_bg

      opts.options.theme = custom_catppuccin

      -- do not add trouble symbols if aerial is enabled
      -- And allow it to be overriden for some buffer types (see autocmds)
      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "lsp_document_symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.winbar.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end
      table.insert(opts.sections.lualine_z, lsp)
      --table.insert(opts.sections.lualine_b, space)
      return opts
    end,
  },
}
