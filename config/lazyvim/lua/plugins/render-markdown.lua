-- HACK: to show the virtual text above line 1 for L1 headers.
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*.md",
  callback = function()
    local ctrl_y = vim.api.nvim_replace_termcodes("<c-y>", true, false, true)
    vim.schedule(function()
      local current_position = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys(ctrl_y, "n", true)
      vim.api.nvim_win_set_cursor(0, current_position)
    end)
  end,
})

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    checkbox = {
      enabled = true,
      position = "inline",
      unchecked = { icon = " 󰄱 " },
      checked = { icon = " 󰱒 " },
    },
    heading = {
      border = true,
      width = "block",
      right_pad = 2,
      min_width = 30,
      position = "inline",
      icons = { "█ ", "██ ", "███ ", "████ ", "█████ ", "██████ " },
    },
    html = { comment = { conceal = false } },
  },
}
