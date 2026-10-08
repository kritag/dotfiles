return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shuck" },
          bash = { "shuck" },
          zsh = { "shuck" },
          kdl = { "kdlfmt" },
          css = { "prettierd" },
          toml = { "tombi" },
          javascript = { "prettierd" },
          hcl = { "packer_fmt" },
          terraform = { "terraform_fmt" },
          tf = { "terraform_fmt" },
          ["terraform-vars"] = { "terraform_fmt" },
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
          json = { "fixjson", "prettier_json" },
          jsonc = { "fixjson", "prettier_json" },
        },
        formatters = {
          fixjson = { prepend_args = { "-i", "2" } },
          -- Separate from "prettier" above, which is tuned for markdown.
          -- ~/.prettierrc.json sets tabWidth 4; CLI flags override it.
          prettier_json = {
            command = "prettier",
            args = {
              "--stdin-filepath",
              "$FILENAME",
              "--tab-width",
              "2",
              "--print-width",
              "100",
            },
          },
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
            command = "mdformat",
            prepend_args = {
              "--wrap",
              "80",
              "--align-semantic-breaks-in-lists",
            },
          },
          shuck = {
            command = "shuck",
            args = { "format", "--stdin-filename", "$FILENAME", "-" },
          },
          injected = { options = { ignore_errors = true } },
        },
      }
      return opts
    end,
  },
}
