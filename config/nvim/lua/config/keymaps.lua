-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- -----
-- NVIM LSP
-- -------

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>db", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local Util = require("lazyvim.util")

vim.keymap.set("n", "<leader>ft", function()
    Util.float_term(nil, { cwd = Util.get_root(), border = "single" })
end, { desc = "Terminal (root dir)" })

vim.keymap.set("n", "<tab>", function()
    vim.cmd("bn")
end, { desc = "Next buffer" })
vim.keymap.set("n", "<s-tab>", function()
    vim.cmd("bp")
end, { desc = "Previous buffer" })
