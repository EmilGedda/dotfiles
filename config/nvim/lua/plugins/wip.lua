-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--

local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    -- change trouble config
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- opts will be merged with the parent spec
        opts = { use_diagnostic_signs = true },
    },

    -- add symbols-outline
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        config = true,
    },

    -- change some telescope options and a keymap to browse plugin files
    { "nvim-telescope/telescope.nvim" },

    -- add telescope-fzf-native
    {
        "telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                require("telescope").load_extension("fzf")
            end,
        },

        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
        },
        keys = {
            {
                "<leader>rg",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Fuzzy search",
            },
        },
    },

    -- add lspconfig
    { "neovim/nvim-lspconfig" },

    -- add treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cmake",
                "cpp",
                "html",
                "javascript",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "ninja",
                "python",
                "query",
                "regex",
                "vim",
                "vimdoc",
                "yaml",
            },

            tree_docs = { enable = true },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["äf"] = "@function.outer",
                        ["äc"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["äF"] = "@function.outer",
                        ["äC"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["öf"] = "@function.outer",
                        ["öc"] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["öF"] = "@function.outer",
                        ["öC"] = "@class.outer",
                    },
                },
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding xor succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    include_surrounding_whitespace = true,
                },
            },
        },
    },

    { "nvim-tree/nvim-web-devicons" },

    -- or you can return new options to override all the defaults
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_)
            local icons = require("lazyvim.config").icons

            return {
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {},
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                            on_click = function()
                                require("trouble").toggle()
                            end,
                        },
                        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                        },
                    },
                    -- lualine_x = {
                    --   {
                    --     "diff",
                    --     symbols = {
                    --       added = icons.git.added,
                    --       modified = icons.git.modified,
                    --       removed = icons.git.removed,
                    --     },
                    --   },
                    -- },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = { "branch" },
                },
                tabline = {
                    lualine_a = { "buffers" },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "tabs" },
                },
                extensions = { "neo-tree" },
            }
        end,
    },

    -- add jsonls and schemastore ans setup treesitter for json, json5 and jsonc
    { import = "lazyvim.plugins.extras.lang.json" },

    -- add any tools you want to have installed below
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "clangd",
            },
        },
    },

    { "echasnovski/mini.surround", enabled = false },
    { "echasnovski/mini.pairs", enabled = false },
    { "echasnovski/mini.ai", enabled = false },

    -- Use <tab> for completion and snippets (supertab)
    -- first: disable default <tab> and <s-tab> behavior in LuaSnip
    -- then: setup supertab in cmp
    {
        "hrsh7th/nvim-cmp",
        version = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            return {

                completion = {
                    completeopt = "menu,menuone,noinsert",
                },

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = function(_, item)
                        if kind_icons[item.kind] then
                            item.kind = string.format("%s %s", kind_icons[item.kind], item.kind) -- This concatonates the icons with the name of the item kind
                        end
                        return item
                    end,
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- they way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            }
        end,
    },
}
