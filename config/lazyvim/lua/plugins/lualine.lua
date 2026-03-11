local function getLspName()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_ft = vim.bo[bufnr].filetype

  local names = {}

  -- 1) LSP clients
  local ok_clients, buf_clients = pcall(vim.lsp.get_clients, { bufnr = bufnr })
  if ok_clients and buf_clients and not vim.tbl_isempty(buf_clients) then
    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" then
        table.insert(names, client.name)
      end
    end
  end

  -- 2) nvim-lint linters (condition-aware, fail-safe)
  local ok_lint, lint = pcall(require, "lint")
  if ok_lint then
    local ft_linters = type(lint._resolve_linter_by_ft) == "function" and lint._resolve_linter_by_ft(buf_ft)
      or lint.linters_by_ft[buf_ft]
    if ft_linters then
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local ctx = { filename = filename, dirname = vim.fn.fnamemodify(filename, ":h") }
      for _, linter_name in ipairs(ft_linters) do
        local linter = lint.linters[linter_name]
        if type(linter) == "function" then
          local ok_linter, resolved = pcall(linter)
          linter = ok_linter and resolved or nil
        end
        if type(linter) == "table" then
          local run = true
          if type(linter.condition) == "function" then
            local ok_cond, result = pcall(linter.condition, ctx)
            run = ok_cond and result
          end
          if run then
            table.insert(names, linter_name)
          end
        end
      end
    end
  end

  -- 3) conform.nvim formatters (prefer runtime resolver)
  local ok_conf, conform = pcall(require, "conform")
  if ok_conf then
    if type(conform.list_formatters_to_run) == "function" then
      local ok_run, infos, uses_lsp = pcall(conform.list_formatters_to_run, bufnr)
      if ok_run then
        for _, info in ipairs(infos or {}) do
          if info and info.name then
            table.insert(names, info.name)
          end
        end
        if uses_lsp then
          table.insert(names, "lsp_format")
        end
      end
    else
      local entry = conform.formatters_by_ft and conform.formatters_by_ft[buf_ft]
      local formatters = type(entry) == "function" and entry(bufnr) or entry
      if type(formatters) == "table" then
        vim.list_extend(names, formatters)
      elseif type(formatters) == "string" then
        table.insert(names, formatters)
      end
    end
  end

  -- 4) Deduplicate
  local hash, unique = {}, {}
  for _, v in ipairs(names) do
    if not hash[v] then
      table.insert(unique, v)
      hash[v] = true
    end
  end

  -- 5) Return comma-separated string
  return #unique > 0 and table.concat(unique, ", ") or "  No servers"
end

local lsp = {
  function()
    local ok, value = pcall(getLspName)
    return ok and value or "tools: error"
  end,
  separator = { left = "" },
}
local space = {
  function()
    return " "
  end,
  separator = { right = "" },
}
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    --event = { "BufReadPost", "BufNewFile" },
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
    opts = function(_, opts)
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          -- section_separators = "",
          --{ left = "", right = "" },
          always_divide_middle = true,
          component_separators = "",
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
            winbar = { "neo-tree", "dashboard", "alpha", "ministarter", "snacks_dashboard" },
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              separator = { right = "" },
              -- color = { bg = "transparent_bg" },
            },
          },
          lualine_b = { space },
          lualine_c = {
            {
              "branch",
              separator = { left = "", right = "" },
            },
            {
              "diff",
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
              -- color = { bg = colors.transparent_bg, fg = colors.blue },
            },
            {
              function()
                local component = LazyVim.lualine.root_dir() -- Retrieve the component
                return component[1]() -- Execute the function part of the component
              end,
              separator = { left = "", right = "" }, -- Apply separators
              -- color = { fg = colors.crust, bg = colors.pink, gui = "bold" },
            },
            {
              "diagnostics",
              -- color = { bg = colors.surface0, fg = colors.blue, gui = "bold" },
              separator = { right = "" },
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_x = {
            Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
          },
          lualine_y = {
            {
              "progress",
              separator = { left = "", right = "" },
              padding = { left = 1, right = 1 },
              -- color = { bg = colors.surface0, fg = colors.blue, gui = "bold" },
            },
            {
              "location",
              padding = { left = 1, right = 1 },
              -- color = { bg = colors.surface0, fg = colors.blue, gui = "bold" },
            },
          },
          lualine_z = { lsp },
        },
        winbar = {
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              cond = nil,
              separator = "",
              padding = { left = 0, right = 0 },
              color = { bg = "None" },
            },
            {
              LazyVim.lualine.pretty_path(),
              color = { bg = "None" },
            },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
      --
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
          hl_group = "lualine_c_20_normal",
        })
        table.insert(opts.winbar.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end
      table.insert(
        opts.sections.lualine_x,
        2,
        LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
          local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
          if #clients > 0 then
            local status = require("copilot.status").data.status
            return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
          end
        end)
      )
      return opts
    end,
  },
}
