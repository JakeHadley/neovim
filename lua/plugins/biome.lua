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
}
