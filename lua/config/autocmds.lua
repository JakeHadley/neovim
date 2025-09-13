-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function set_indent_from_biome()
  local biome_config = vim.fn.findfile("biome.json", vim.fn.expand("%:p:h") .. ";")
  if biome_config == "" then
    return
  end

  local file = io.open(biome_config, "r")
  if not file then
    return
  end

  local content = file:read("*a")
  file:close()

  local ok, biome = pcall(vim.fn.json_decode, content)
  if not ok or not biome.formatter then
    return
  end

  local indent_width = biome.formatter.indentWidth or 2
  vim.bo.tabstop = indent_width
  vim.bo.shiftwidth = indent_width
  vim.bo.softtabstop = indent_width
  vim.bo.expandtab = (biome.formatter.indentStyle == "space")
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json" },
  callback = set_indent_from_biome,
})
