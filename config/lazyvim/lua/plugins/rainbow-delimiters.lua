return {
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
    --  local colors = {
    --    Red = "#EF6D6D",
    --    Orange = "#FFA645",
    --    Yellow = "#EDEF56",
    --    Green = "#6AEF6F",
    --    Cyan = "#78E6EF",
    --    Blue = "#70A4FF",
    --    Violet = "#BDB2EF",
    --  }
    --  require("pynappo.theme").set_rainbow_colors("RainbowDelimiter", colors) -- just a helper function that sets the highlights with the given prefix
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
      },
      highlight = {
        "RainbowDelimiterCyan",
        "RainbowDelimiterYellow",
        "RainbowDelimiterViolet",
        "RainbowDelimiterGreen",
        "RainbowDelimiterBlue",
        "RainbowDelimiterRed",
        "RainbowDelimiterOrange",
      },
    }
  end,
}
