-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>al", function()
  local word = vim.fn.expand("<cword>")
  local log = "console.log(" .. word .. ");"

  -- Use the unnamed register and make it behave like a real yank
  vim.fn.setreg('"', log) -- put it in register a temporarily
end, { desc = "Copy console.log(<word>) to register" })
