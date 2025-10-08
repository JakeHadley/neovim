-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function get_indent_width_from_content(content)
  -- This pattern matches: "indentWidth": <number>
  local indent_width = content:match([["indentWidth"%s*:%s*(%d+)]])
  if indent_width then
    return tonumber(indent_width)
  end
  return nil
end

local function get_indent_style_from_content(content)
  local indent_style = content:match([["indentStyle"%s*:%s*"(%a+)"]])
  return indent_style -- returns "space", "tab", or nil
end

local function set_indent_from_biome()
  local dir = vim.fn.expand("%:p:h") .. ";"
  local biome_json = vim.fn.findfile("biome.json", dir)
  local biome_jsonc = vim.fn.findfile("biome.jsonc", dir)
  local biome_config = biome_json ~= "" and biome_json or biome_jsonc

  if biome_config == "" then
    return
  end

  local file = io.open(biome_config, "r")
  if not file then
    return
  end

  local content = file:read("*a")
  file:close()

  local indent_width = get_indent_width_from_content(content) or 4
  local indent_style = get_indent_style_from_content(content) or "space"

  vim.bo.tabstop = indent_width
  vim.bo.shiftwidth = indent_width
  vim.bo.softtabstop = indent_width
  vim.bo.expandtab = (indent_style == "space")
end

-- local function set_indent_from_biome()
--   local dir = vim.fn.expand("%:p:h") .. ";"
--   local biome_json = vim.fn.findfile("biome.json", dir)
--   local biome_jsonc = vim.fn.findfile("biome.jsonc", dir)
--   local biome_config = biome_json ~= "" and biome_json or biome_jsonc
--   print("set_indent_from_biome called for " .. vim.api.nvim_buf_get_name(0))
--
--   if biome_config == "" then
--     return
--   end
--
--   local file = io.open(biome_config, "r")
--   if not file then
--     return
--   end
--
--   local content = file:read("*a")
--   file:close()
--
--   if biome_config:match("%.jsonc$") then
--     content = strip_jsonc_comments(content)
--     print(content)
--   end
--
--   local ok, biome = pcall(vim.fn.json_decode, content)
--   print("ok", ok)
--   print("biome", biome.formatter)
--   if not ok or not biome.formatter then
--     return
--   end
--
--   local indent_width = biome.formatter.indentWidth or 4
--   print("tabstop: ", indent_width)
--   vim.bo.tabstop = indent_width
--   vim.bo.shiftwidth = indent_width
--   vim.bo.softtabstop = indent_width
--   vim.bo.expandtab = (biome.formatter.indentStyle == "space")
-- end

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json" },
  callback = set_indent_from_biome,
})
