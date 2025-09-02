return {
  {
    "stevearc/conform.nvim",
    enable = false,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "biome",
      },
    },
  },
}
