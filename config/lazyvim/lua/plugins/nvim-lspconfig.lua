return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
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
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          before_init = function(_, new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              hover = true,
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = {
                ["https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json"] = "*omp*.{yml,yaml}",
                ["https://f.jstanger.dev/github/ironbar/schema.json"] = "*ironbar/*conf*.{yml,yaml}",
                ["https://www.schemastore.org/github-issue-forms.json"] = "**/.github/ISSUE_TEMPLATE/*.{yml,yamk}",
              },
            },
          },
          -- New on_attach to skip GH Actions YAML files
          on_attach = function(client, bufnr)
            local filepath = vim.api.nvim_buf_get_name(bufnr)
            if filepath:match(".github/workflows/.*%.yml$") or filepath:match(".github/workflows/.*%.yaml$") then
              client.stop()
              return
            end

            -- Optional: add your own buffer-local keymaps here if needed
          end,
        },
      },
    },
  },
}
