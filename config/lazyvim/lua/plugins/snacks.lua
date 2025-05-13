return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      hidden = true,
      ignored = true,
      exclude = { "node_modules", ".git" },
    },
    picker = {
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          truncate = 80,
        },
      },
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true },
      },
    },
    -- Folke pointed me to the snacks docs
    -- https://github.com/LazyVim/LazyVim/discussions/4251#discussioncomment-11198069
    -- Here's the lazygit snak docs
    -- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
    lazygit = {
      theme = {
        selectedLineBgColor = { bg = "CursorLine" },
      },
      -- With this I make lazygit to use the entire screen, because by default there's
      -- "padding" added around the sides
      -- I asked in LazyGit, folke didn't like it xD xD xD
      -- https://github.com/folke/snacks.nvim/issues/719
    },
    styles = {
      snacks_image = {
        relative = "editor",
        col = -1,
      },
    },
    image = {
      enabled = true,
      doc = {
        -- Personally I set this to false, I don't want to render all the
        -- images in the file, only when I hover over them
        -- render the image inline in the buffer
        -- if your env doesn't support unicode placeholders, this will be disabled
        -- takes precedence over `opts.float` on supported terminals
        inline = vim.g.neovim_mode == "skitty" and true or false,
        -- only_render_image_at_cursor = vim.g.neovim_mode == "skitty" and false or true,
        -- render the image in a floating window
        -- only used if `opts.inline` is disabled
        float = true,
        -- Sets the size of the image
        -- max_width = 60,
        -- max_width = vim.g.neovim_mode == "skitty" and 20 or 60,
        -- max_height = vim.g.neovim_mode == "skitty" and 10 or 30,
        max_width = vim.g.neovim_mode == "skitty" and 5 or 60,
        max_height = vim.g.neovim_mode == "skitty" and 2.5 or 30,
        -- max_height = 30,
        -- Apparently, all the images that you preview in neovim are converted
        -- to .png and they're cached, original image remains the same, but
        -- the preview you see is a png converted version of that image
        --
        -- Where are the cached images stored?
        -- This path is found in the docs
        -- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
        -- For me returns `~/.cache/neobean/snacks/image`
        -- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
      },
    },
  },
}
