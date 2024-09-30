return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      -- custom_highlights = function(colors)
      --   return {
      --     IblIndent = { fg = colors.surface0 },
      --     IblScope = { fg = colors.text },
      --   }
      -- end,
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
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
