return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Replace the pretty_path with the full relative path
    opts.sections.lualine_c = {
      -- Keep other components as in your setup
      require("lazyvim.util").lualine.root_dir(),
      {
        "diagnostics",
        symbols = {
          error = require("lazyvim.config").icons.diagnostics.Error,
          warn = require("lazyvim.config").icons.diagnostics.Warn,
          info = require("lazyvim.config").icons.diagnostics.Info,
          hint = require("lazyvim.config").icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { "filename", path = 1 }, -- This shows the full relative path
    }
  end,
}
