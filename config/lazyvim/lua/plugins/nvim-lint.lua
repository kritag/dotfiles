return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      bash = { "shellcheck" },
      markdown = { "markdownlint-cli2" },
      yaml = { "yamllint", "kube-linter" },
      -- lua = { "selene" },
    },
    linters = {
      yamllint = {
        args = { "-d", "relaxed", "--format", "parsable", "-" },
      },
      ["kube-linter"] = {
        cmd = "kube-linter",
        stdin = false,
        append_fname = true,
        args = { "lint" },
        ignore_exitcode = true,
        parser = function(output)
          local diagnostics = {}
          for line in vim.gsplit(output, "\n", true) do
            local filename, message = line:match("^([^:]+): (.+)")
            if message then
              table.insert(diagnostics, {
                lnum = 0,
                col = 0,
                severity = vim.diagnostic.severity.WARN,
                source = "kube-linter",
                message = message,
              })
            end
          end
          return diagnostics
        end,
        condition = function(ctx)
          -- Only enable kube-linter if the file *appears* to be a K8s manifest
          local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
          for _, l in ipairs(lines) do
            if l:match("^%s*apiVersion:") or l:match("^%s*kind:") then
              return true
            end
          end
          return false
        end,
      },
    },
  },
  config = function(_, opts)
    local M = {}

    local lint = require("lint")
    for name, linter in pairs(opts.linters) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        if type(linter.prepend_args) == "table" then
          lint.linters[name].args = lint.linters[name].args or {}
          vim.list_extend(lint.linters[name].args, linter.prepend_args)
        end
      else
        lint.linters[name] = linter
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    function M.debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    function M.lint()
      -- Use nvim-lint's logic first:
      -- * checks if linters exist for the full filetype first
      -- * otherwise will split filetype by "." and add all those linters
      -- * this differs from conform.nvim which only uses the first filetype that has a formatter
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)

      -- Create a copy of the names table to avoid modifying the original.
      names = vim.list_extend({}, names)

      -- Add fallback linters.
      if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
      end

      -- Add global linters.
      vim.list_extend(names, lint.linters_by_ft["*"] or {})

      -- Filter out linters that don't exist or don't match the condition.
      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      -- names = vim.tbl_filter(function(name)
      --   local linter = lint.linters[name]
      --   if not linter then
      --     LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
      --   end
      --   return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      -- end, names)

      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
          LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
          return false
        end
        if type(linter) == "table" and type(linter.condition) == "function" then
          local ok, result = pcall(linter.condition, ctx)
          if not ok then
            LazyVim.warn("Error in condition for " .. name .. ": " .. result, { title = "nvim-lint" })
            return false
          end
          if not result then
            -- vim.schedule(function()
            --   vim.notify("Skipping " .. name .. " (condition not met)", vim.log.levels.TRACE)
            -- end)
            return false
          end
        end
        return true
      end, names)

      -- Run linters.
      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = M.debounce(100, M.lint),
    })
  end,
}
