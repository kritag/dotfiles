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
          on_new_config = function(new_config)
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
              },
            },
          },
        },
      },
      setup = {
        yamlls = function()
          -- Neovim < 0.10 does not have dynamic registration for formatting
          if vim.fn.has("nvim-0.10") == 0 then
            LazyVim.lsp.on_attach(function(client, _)
              client.server_capabilities.documentFormattingProvider = true
            end, "yamlls")
          end
        end,
      },
    },
  },
}
