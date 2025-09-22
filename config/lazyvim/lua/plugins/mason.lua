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
      },
      ui = {
        border = "rounded",
      },
    },
  },
}
