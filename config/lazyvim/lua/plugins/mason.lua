return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
        "hyprls",
        "eslint_d",
        "css-lsp"
      },
      ui = {
        border = "rounded",
      },
    },
  },
}
