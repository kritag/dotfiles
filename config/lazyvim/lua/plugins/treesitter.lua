return {
  "nvim-treesitter/nvim-treesitter",
  -- everything else comes from LazyVim and the lang/dot extras
  opts = { ensure_installed = { "comment", "css", "hyprlang", "ini", "make" } },
  init = function()
    vim.treesitter.language.register("bash", "zsh")
  end,
}
