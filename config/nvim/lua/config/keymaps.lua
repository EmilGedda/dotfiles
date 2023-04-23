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
--
--
local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

local opts = { noremap = true, silent = true }
map("n", "<space>e", vim.diagnostic.open_float, opts)
map("n", "<leader>df", vim.diagnostic.goto_next, opts)
map("n", "<leader>db", vim.diagnostic.goto_prev, opts)
map("n", "<space>q", vim.diagnostic.setloclist, opts)

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
