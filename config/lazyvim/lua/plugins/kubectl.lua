return {
  {
    "ramilito/kubectl.nvim",
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
