return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          css = { "prettierd" },
          yaml = { "yamlfix" },
          -- ["markdown"] = { "markdownlint-cli2" },
          -- ["markdown.mdx"] = { "markdownlint-cli2" },
          ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
          ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
          -- json = { "prettierd" },
          -- jsonc = { "prettierd" },
        },
        formatters = {
          prettier = {
            prepend_args = {
              "--prose-wrap",
              "always",
              "--tab-width",
              "2",
              "--print-width",
              "80",
            },
          },
          injected = { options = { ignore_errors = true } },
        },
      }
      return opts
    end,
  },
}
