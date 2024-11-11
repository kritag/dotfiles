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
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        leap = true,
        lsp_trouble = true,
        mason = true,
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
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = {
          enabled = true,
          -- style = "nvchad",
        },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
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
  {
    "gbprod/nord.nvim",
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
