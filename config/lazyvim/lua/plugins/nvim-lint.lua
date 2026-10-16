return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      bash = { "shellcheck" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      json = { "jsonlint" },
      markdown = { "markdownlint-cli2" },
      python = { "pylint" },
      svelte = { "eslint_d" },
      terraform = { "terraform_validate" },
      tf = { "terraform_validate" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      yaml = { "yamllint", "kube-linter", "actionlint" },
      -- lua = { "selene" },
    },
    linters = {
      yamllint = {
        args = { "-d", "{extends: relaxed, rules: {line-length: disable}}", "--format", "parsable", "-" },
        condition = function(ctx)
          return not ctx.filename:match("/%.github/workflows/")
        end,
      },
      actionlint = {
        cmd = "actionlint",
        stdin = true,
        ignore_exitcode = true,
        parser = function(output)
          local diagnostics = {}
          for line in output:gmatch("[^\r\n]+") do
            local file, lnum, col, msg = line:match("^([^:]+):(%d+):(%d+): (.+)$")
            if file and lnum and col and msg then
              table.insert(diagnostics, {
                lnum = tonumber(lnum) - 1,
                col = tonumber(col) - 1,
                severity = vim.diagnostic.severity.ERROR,
                source = "actionlint",
                message = msg,
              })
            end
          end
          return diagnostics
        end,
        condition = function(ctx)
          -- Only run actionlint for files inside GitHub workflows
          if ctx.filename:match("/%.github/workflows/") then
            return true
          end
          return false
        end,
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
                -- severity = vim.diagnostic.severity.WARN,
                source = "kube-linter",
                message = message,
              })
            end
          end
          return diagnostics
        end,
        condition = function(ctx)
          -- Only enable kube-linter for K8s manifests outside GitHub workflows
          if ctx.filename:match("/%.github/workflows/") then
            return false
          end
          for _, l in ipairs(vim.api.nvim_buf_get_lines(0, 0, 20, false)) do
            if l:match("^%s*apiVersion:") or l:match("^%s*kind:") then
              return true
            end
          end
          return false
        end,
      },
    },
  },
}
