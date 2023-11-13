-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--

-- icons used by other plugins

local icons = require("util").icons

return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        event = "InsertEnter",
        version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        build = (not jit.os:find("Windows"))
                and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
            or nil,
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
		-- stylua: ignore
		keys = {
			{
				"<tab>",
				function()
					return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
				end,
				expr = true, silent = true, mode = "i",
			},
			{ "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
			{ "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
		},
    },
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
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
            local defaults = require("cmp.config.default")()
            local neogen = require("neogen")

            return {

                completion = {
                    completeopt = "menu,menuone",
                },

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = function(_, item)
                        if icons.kinds[item.kind] then
                            item.kind = string.format("%s %s", icons.kinds[item.kind], item.kind) -- This concatonates the icons with the name of the item kind
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

                sorting = defaults.sorting,

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
                        elseif neogen.jumpable() then
                            neogen.jump_next()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif neogen.jumpable(-1) then
                            neogen.jump_prev()
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

    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {},
    },

    -- comments
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {
            enable_autocmd = false,
        },
    },

    -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
    {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        event = "VeryLazy",
        lazy = false,
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
        opts = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    },
    -- Better text-objects
    {
        "echasnovski/mini.ai",
        -- keys = {
        --   { "a", mode = { "x", "o" } },
        --   { "i", mode = { "x", "o" } },
        -- },
        event = "VeryLazy",
        dependencies = { "nvim-treesitter-textobjects" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            -- register all text objects with which-key
            require("util").on_load("which-key.nvim", function()
                ---@type table<string, string|table>
                local i = {
                    [" "] = "Whitespace",
                    ['"'] = 'Balanced "',
                    ["'"] = "Balanced '",
                    ["`"] = "Balanced `",
                    ["("] = "Balanced (",
                    [")"] = "Balanced ) including white-space",
                    [">"] = "Balanced > including white-space",
                    ["<lt>"] = "Balanced <",
                    ["]"] = "Balanced ] including white-space",
                    ["["] = "Balanced [",
                    ["}"] = "Balanced } including white-space",
                    ["{"] = "Balanced {",
                    ["?"] = "User Prompt",
                    _ = "Underscore",
                    a = "Argument",
                    b = "Balanced ), ], }",
                    c = "Class",
                    f = "Function",
                    o = "Block, conditional, loop",
                    q = "Quote `, \", '",
                    t = "Tag",
                }
                local a = vim.deepcopy(i)
                for k, v in pairs(a) do
                    a[k] = v:gsub(" including.*", "")
                end

                local ic = vim.deepcopy(i)
                local ac = vim.deepcopy(a)
                for key, name in pairs({ n = "Next", l = "Last" }) do
                    i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
                    a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
                end
                require("which-key").register({
                    mode = { "o", "x" },
                    i = i,
                    a = a,
                })
            end)
        end,
    },
}
