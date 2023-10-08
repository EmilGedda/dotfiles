return {

    -- { "rebelot/kanagawa.nvim",
    --    lazy = true,
    --    init = function()
    --      vim.cmd.colorscheme("kanagawa-wave")
    --    end
    -- }
    -- {
    --   "EdenEast/nightfox.nvim",
    --   lazy = true,
    --   init = function()
    --     vim.cmd.colorscheme("nightfox")
    --   end
    -- }
    --
    --
    -- {
    --   'AlexvZyl/nordic.nvim',
    --   lazy = false,
    --   priority = 1000,
    --   config = function()
    --     require('nordic').load()
    --   end
    -- },
    -- {
    --   "folke/tokyonight.nvim",
    --   lazy = true,
    --   opts = { style = "moon" },
    --   init = function()
    --     vim.cmd.colorscheme("tokyonight")
    --   end
    -- },
    -- {
    --   "navarasu/onedark.nvim",
    --   lazy = true,
    --   opts = { style = "warmer" },
    --   init = function()
    --     vim.cmd.colorscheme("onedark")
    --   end
    -- },
    {
        "Mofiqul/vscode.nvim",
        lazy = true,
        opts = {
            color_overrides = {
                vscFront = "#c5c8c6",
                --vscLightBlue = "#c5c8c6",
            },
        },

        -- opts = function(_, opts)
        --     local c = require("vscode.colors").get_colors()
        --     opts["group_overrides"] = {}
        --     opts.group_overrides["@variable"] = { fg = c.vscFront }
        --     opts.group_overrides["@field"] = { fg = c.vscFront }
        --     vim.tbl_deep_extend("force", opts, o)
        -- end,
        init = function()
            vim.cmd.colorscheme("vscode")
            -- remove background color of ctrl+k
            vim.cmd("hi clear Pmenu")
        end,
    },
}
