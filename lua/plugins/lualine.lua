return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = require("lazyvim.config").icons
    local util = require("lazyvim.util")
    local lualine_sections = {
      util.lualine.root_dir(),
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { "filename", path = 1 }, -- full relative path
    }

    -- Add trouble.nvim scope if enabled
    if vim.g.trouble_lualine and require("lazyvim.util").has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(lualine_sections, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    opts.sections.lualine_c = lualine_sections
  end,
}
