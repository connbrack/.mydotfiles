return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		ts = require("nvim-treesitter")
		ts.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})
		ts.install({
			"bash",
			"javascript",
			"typescript",
			"lua",
			"python",
			"rust",
		})


		vim.api.nvim_create_autocmd("FileType", {
		  callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		  end,
		})
	end,
}
