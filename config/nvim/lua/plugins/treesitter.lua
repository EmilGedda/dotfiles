local load_textobjects = false
return {
	-- Treesitter is a new parser generator tool that we can
	-- use in Neovim to power faster and more accurate
	-- syntax highlighting.
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- disable rtp plugin, as we only need its queries for mini.ai
					-- In case other textobject modules are enabled, we will load them
					-- once nvim-treesitter is loaded
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					load_textobjects = true
				end,
			},
		},
		cmd = { "TSUpdateSync" },
		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		---@type TSConfig
		opts = {
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
			highlight = { enable = true },
			indent = { enable = true },
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
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require("nvim-treesitter.configs").setup(opts)
			for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
				if opts.textobjects[mod] and opts.textobjects[mod].enable then
					local Loader = require("lazy.core.loader")
					Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
					local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
					require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
					break
				end
			end
		end,
	},
}
