return {
  "kritag/k8s-yaml-schemas.nvim",
  event = "FileType yaml",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local mod = require("k8s-yaml-schemas")
    -- If you used the default path (~/.config/nvim/k8s-yaml-schemas.json),
    -- you don't need to pass anything to setup(). Otherwise:
    mod.setup({
      config_file = vim.fn.expand("~/.config/k8s/k8s-yaml-schemas.yaml"),
      crd_store_source = "OpenShift (internal)", -- custom resources in multi-object files
    })
    mod.setup_autocmd()
  end,
}
