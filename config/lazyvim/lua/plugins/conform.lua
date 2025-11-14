return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          css = { "prettierd" },
          python = {
            -- To fix auto-fixable lint errors.
            "ruff_fix",
            -- To run the Ruff formatter.
            "ruff_format",
            -- To organize the imports.
            "ruff_organize_imports",
          },
          yaml = { "yamlfmt" },
          -- ["markdown"] = { "markdownlint-cli2" },
          -- ["markdown.mdx"] = { "markdownlint-cli2" },
          -- ["markdown"] = { "mdformat", "prettier", "markdownlint-cli2", "markdown-toc" },
          ["markdown.mdx"] = { "mdformat", "prettier", "markdownlint-cli2", "markdown-toc" },
          markdown = { "mdformat" },
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
          mdformat = {
            prepend_args = {
              "--wrap",
              "80",
              "--align-semantic-breaks-in-list",
            },
          },
          injected = { options = { ignore_errors = true } },
        },
      }
      return opts
    end,
  },
}
