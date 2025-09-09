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
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = function()
      local block = ""
      return {
        enabled = true,
        bullet = {
          enabled = true,
        },
        checkbox = {
          enabled = true,
          position = "inline",
          unchecked = {
            icon = " 󰄱 ",
            highlight = "RenderMarkdownUnchecked",
            scope_highlight = nil,
          },
          checked = {
            icon = " 󰱒 ",
            highlight = "RenderMarkdownChecked",
            scope_highlight = nil,
          },
        },
        html = {
          enabled = true,
          comment = {
            conceal = false,
          },
        },
        pipe_table = {
          enabled = true,
          style = "full", -- ensures top and bottom borders are drawn properly
          cell = "padded", -- better visual structure
          padding = 1,
          min_width = 0,
          -- additional tweaks:
          -- cell = 'trimmed'  -- if you want narrower cells that cut extra padding
          -- or try `cell = 'overlay'` if you're okay with losing conceal behavior
        },
        heading = {
          enabled = true,
          border = true,
          border_prefix = false,
          sign = false,
          width = "block",
          left_pad = 0,
          right_pad = 2,
          left_margin = 0,
          min_width = 30,
          position = "inline",
          icons = { "█ ", "██ ", "███ ", "████ ", "█████ ", "██████ " },
          backgrounds = {
            "RenderMarkdownH1Bg",
            "RenderMarkdownH2Bg",
            "RenderMarkdownH3Bg",
            "RenderMarkdownH4Bg",
            "RenderMarkdownH5Bg",
            "RenderMarkdownH6Bg",
          },
          foregrounds = {
            "RenderMarkdownH1",
            "RenderMarkdownH2",
            "RenderMarkdownH3",
            "RenderMarkdownH4",
            "RenderMarkdownH5",
            "RenderMarkdownH6",
          },
        },
      }
    end,
    -- heading = {
    --   border = true,
    --   border_virtual = true,
    --   left_pad = 1,
    --   sign = false,
    --   -- icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
    --   icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    --   -- icons = { " 󰬺 ", "", "", "", "", "" },
    --   border_prefix = true,
    --   -- Used above heading for border.
    --   above = "▄",
    --   -- Used below heading for border.
    --   below = "▀",
    -- },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },
}
