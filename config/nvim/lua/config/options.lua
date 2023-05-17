vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.o.completeopt = "menu,menuone,noselect"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

vim.api.nvim_set_hl(0, "GhostText", { italic = true, fg = "#808080" })

local opt = vim.opt

opt.relativenumber = false -- Relative line numbers
opt.shortmess = vim.o.shortmess .. "c"
opt.joinspaces = false

local M = {}
_G.Status = M

---@return {name:string, text:string, texthl:string}[]
function M.get_signs()
    local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    return vim.tbl_map(function(sign)
        return vim.fn.sign_getdefined(sign.name)[1]
    end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

function M.colored_gutter()
    local sign, git_sign
    for _, s in ipairs(M.get_signs()) do
        if s.name:find("GitSign") then
            git_sign = s
        else
            sign = s
        end
    end
    local components = {
        [[%=]],
        sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or " ",
        [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]],
        (git_sign and ("%#" .. git_sign.texthl .. "#") or "") .. "▏%*",
    }
    return table.concat(components, "")
end

function M.colored_numbers()
    local sign, git_sign
    for _, s in ipairs(M.get_signs()) do
        if s.name:find("GitSign") then
            git_sign = s
        else
            sign = s
        end
    end
    local components = {
        [[%=]],
        sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or " ",
        (git_sign and ("%#" .. git_sign.texthl .. "#") or ""),
        [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]],
    }
    return table.concat(components, "")
end

opt.statuscolumn = [[%!v:lua.Status.colored_gutter()]]
