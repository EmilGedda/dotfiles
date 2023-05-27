-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any add:itional autocmds here

local function augroup(name)
    return vim.api.nvim_create_augroup("local_" .. name, { clear = true })
end

local scl = augroup("statuscolumn")

-- streamline terminal buffer opening
vim.api.nvim_create_autocmd("TermOpen", {
    group = scl,
    callback = function()
        vim.opt_local.signcolumn = "no"
        vim.opt_local.number = false
        vim.cmd.startinsert()
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = scl,
    callback = function()
        vim.opt_local.statuscolumn = [[%!v:lua.GitDiff.gutter()]]
    end,
})
-- close term if shell exists
vim.api.nvim_create_autocmd("TermClose", {
    group = augroup("close_term"),
    callback = function()
        vim.cmd("bdelete! " .. vim.fn.expand("<abuf>"))
    end,
})
