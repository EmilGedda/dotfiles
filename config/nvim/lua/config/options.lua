vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.api.nvim_set_hl(0, "GhostText", { italic = true, fg = "#808080" })

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = false -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.splitkeep = "screen"
opt.shortmess:append({ C = true })
opt.joinspaces = false
opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos", "terminal" }
opt.softtabstop = 2
opt.termguicolors = true
opt.mousemoveevent = true

-- prevent gitsigns from creating a signcolumn since we use the gutter instead
vim.cmd("set signcolumn=number")

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local M = {}
_G.GitDiff = M

---@return {name:string, text:string, texthl:string}[]
function M.get_signs()
    local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    return vim.tbl_map(function(sign)
        return vim.fn.sign_getdefined(sign.name)[1]
    end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

function M.gutter()
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
        [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):' '} ]],
        (git_sign and ("%#" .. git_sign.texthl .. "#") or "") .. "▏%*",
    }
    return table.concat(components, "")
end

function M.numbers()
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
