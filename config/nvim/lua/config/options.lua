vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.o.completeopt = "menu,menuone,noselect"

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

vim.api.nvim_set_hl(0, "GhostText", { italic = true, fg = "#808080" })

local opt = vim.opt

opt.joinspaces = false
opt.relativenumber = false -- Relative line numbers
opt.shortmess = vim.o.shortmess .. "c"
opt.signcolumn = "number"

opt.shiftwidth = 4
opt.tabstop = 4

require("config.os")
