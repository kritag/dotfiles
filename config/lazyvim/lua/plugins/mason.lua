return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
        "hyprls",
      },
      ui = {
        border = "rounded",
      },
    },
  },
}
