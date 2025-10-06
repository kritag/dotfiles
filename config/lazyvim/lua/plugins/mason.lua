return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
        "hyprls",
        "eslint_d",
        "pylint",
        "css-lsp",
        "prettier",
        "prettierd",
        "yamlfix",
      },
      ui = {
        border = "rounded",
      },
    },
  },
}
