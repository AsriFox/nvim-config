return {
	{
		'nvim-treesitter/nvim-treesitter',
		version = false,
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		event = 'VeryLazy',
		init = function(plugin)
			require('lazy.core.loader').add_to_rtp(plugin)
			require 'nvim-treesitter.query_predicates'
		end,
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				'bash', 'c', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'toml', 'yaml',
			},
		},
		config = function(_, opts)
			local added = {}
			opts.ensure_installed = vim.tbl_filter(function(lang)
				if added[lang] then
					return false
				end
				added[lang] = true
				return true
			end, opts.ensure_installed)
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
}
