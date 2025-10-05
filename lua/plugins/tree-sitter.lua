return {
	{
		"nvim-treesitter/nvim-treesitter", 
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "python", "lua", "terraform", "hcl", "vim", "vimdoc", "markdown" },
				auto_install = true,
				highlight = {
					enable = true,
				},
			})
		end,
	},
}

