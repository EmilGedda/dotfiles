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
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = { style = "warmer" },
    init = function()
      vim.cmd.colorscheme("onedark")
    end
  },
}
