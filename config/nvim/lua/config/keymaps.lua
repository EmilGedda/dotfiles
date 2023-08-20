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
        opts.noremap = true
        opts.silent = true
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

map("n", "<leader>do", function()
    vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Show diagnostic" })
map("n", "<leader>df", function()
    vim.diagnostic.goto_next({ float = { border = "rounded" } })
end, { desc = "Next diagnostic" })
map("n", "<leader>db", function()
    vim.diagnostic.goto_prev({ float = { border = "rounded" } })
end, { desc = "Previous diagnostic" })
map("n", "<leader>dq", function()
    vim.diagnostic.setloclist({ float = { border = "rounded" } })
end, { desc = "Diagnostic in qlist" })

local Util = require("lazyvim.util")

map("n", "<leader>ft", function()
    Util.float_term(nil, { cwd = Util.get_root(), border = "rounded" })
end, { desc = "Terminal (root dir)" })

map("n", "<tab>", function()
    vim.cmd("bn")
end, { desc = "Next buffer" })
map("n", "<s-tab>", function()
    vim.cmd("bp")
end, { desc = "Previous buffer" })
