return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {
          settings = {
            css = {
              validate = false,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        tailwindcss = {
          -- -- exclude a filetype from the default_config
          -- filetypes_exclude = { "markdown" },
          -- -- add additional filetypes to the default_config
          -- filetypes_include = { "html", "css", "javascript", "typescript", "vue", "svelte" },
          -- -- to fully override the default_config, change the below
          filetypes = { "html", "css", "javascript", "typescript", "vue", "svelte" },
        },
        yamlls = {
          format = { enable = false },
          settings = {
            yaml = {
              hover = true,
              schemas = {
                ["https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json"] = "*omp*.{yml,yaml}",
                ["https://f.jstanger.dev/github/ironbar/schema.json"] = "*ironbar/*conf*.{yml,yaml}",
                ["https://www.schemastore.org/github-issue-forms.json"] = "**/.github/ISSUE_TEMPLATE/*.{yml,yamk}",
              },
            },
          },
          -- skip GitHub Actions workflow files
          on_attach = function(client, bufnr)
            local filepath = vim.api.nvim_buf_get_name(bufnr)
            if filepath:match(".github/workflows/.*%.ya?ml$") then
              client.stop()
            end
          end,
        },
      },
    },
  },
}
