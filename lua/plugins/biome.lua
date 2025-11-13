return {
  {
    "stevearc/conform.nvim",
    enable = false,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "biome",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {},
      },
    },
    init = function()
      -- Defer the autocommand creation until after plugins load
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local lspconfig = require("lspconfig")
          vim.api.nvim_create_autocmd("FileType", {
            pattern = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "json",
              "jsonc",
              "astro",
              "svelte",
              "vue",
            },
            callback = function()
              local root =
                lspconfig.util.root_pattern("biome.json", "biome.jsonc", "package.json")(vim.api.nvim_buf_get_name(0))
              if root then
                vim.lsp.start({
                  name = "biome",
                  cmd = { "biome", "lsp-proxy" },
                  root_dir = root,
                  single_file_support = false,
                })
              end
            end,
          })
        end,
      })
    end,
  },
}
