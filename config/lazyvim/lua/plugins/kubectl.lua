return {
  {
    "ramilito/kubectl.nvim",
    -- release tags ship pre-built binaries, downloaded through blink.lib
    version = "2.*",
    dependencies = "saghen/blink.lib",
    opts = {
      kubectl_cmd = { cmd = "oc", env = {}, args = {} },
    },
    -- config = function()
    --   require("kubectl").setup({
    --     float_size = {
    --       width = 0.2,
    --       height = 0.2,
    --     },
    --   })
    -- end,
  },
}
