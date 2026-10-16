vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  group = vim.api.nvim_create_augroup("override_picker_hl", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "SnacksPickerAuGroup" })
    vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "SnacksPickerIconField" })
    vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Text" })
  end,
})

return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      flavour = "mocha",
      term_colors = true,
      integrations = {
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        markdown = true,
        mini = {
          enabled = true,
          indentscope_color = "mauve",
        },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        rainbow_delimiters = true,
        semantic_tokens = true,
        treesitter = true,
      },
      highlight_overrides = {
        all = function(colors)
          return {
            NormalFloat = { bg = colors.mantle },
          }
        end,
      },
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true,
    opts = {
      transparent_mode = true,
      contrast = "hard",
    },
  },
  {
    "neanias/everforest-nvim",
    name = "everforest",
    lazy = true,
    opts = {
      background = "hard",
      transparent_background_level = 1,
    },
  },
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    lazy = true,
    opts = {
      background = "hard",
      transparent_bg = true,
    },
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    opts = {
      transparent = true,
      style = "night",
      lualine_bold = true,
      on_colors = function(colors)
        colors.bg_statusline = "None"
      end,
    },
  },
  -- {
  --   "gbprod/nord.nvim",
  --   name = "nord",
  --   lazy = true,
  --   opts = {
  --     transparent = true,
  --   },
  -- },
  {
    "dupeiran001/nord.nvim",
    -- name = "nord",
    lazy = true,
    opts = {
      transparent = true,
    },
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nord",
    lazy = true,
    opts = {
      transparent = true,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "moon",
      styles = {
        transparency = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
