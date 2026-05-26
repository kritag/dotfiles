local ls = require("luasnip")
local s, t, i, f = ls.snippet, ls.text_node, ls.insert_node, ls.function_node

local admonition = function(type)
  return s(type, {
    t({ "!!! " .. type, "    " }),
    i(0),
  })
end

local admonition_titled = function(type)
  return s(type .. "t", {
    t('!!! ' .. type .. ' "'),
    i(1, "Title"),
    t({ '"', "    " }),
    i(0),
  })
end

ls.add_snippets("markdown", {
  admonition("note"),
  admonition("tip"),
  admonition("info"),
  admonition("warning"),
  admonition("danger"),
  admonition("success"),
  admonition("question"),
  admonition("failure"),
  admonition("bug"),
  admonition("example"),
  admonition("quote"),
  admonition_titled("note"),
  admonition_titled("tip"),
  admonition_titled("info"),
  admonition_titled("warning"),
  admonition_titled("danger"),
  admonition_titled("success"),
  admonition_titled("question"),
  admonition_titled("failure"),
  admonition_titled("bug"),
  admonition_titled("example"),
  admonition_titled("quote"),
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
