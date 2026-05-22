local ls = require("luasnip")
local s, t, i, f = ls.snippet, ls.text_node, ls.insert_node, ls.function_node

ls.add_snippets("markdown", {
  s("fm", {
    t({ "---", "title: " }),
    i(1, "Title"),
    t({ "", "date: " }),
    f(function()
      return os.date("%Y-%m-%d")
    end, {}),
    t({ "", "authors:", "  - " }),
    i(2, "Full Name"),
    t({ "", "tags:", "  - " }),
    i(3, "tag"),
    t({ "", "categories:", "  - " }),
    i(4, "category"),
    t({ "", "icon: " }),
    i(5, "material/cogs"),
    t({ "", "search:", "  exclude: " }),
    i(6, "false"),
    t({ "", "---", "" }),
    i(0),
  }),
})
