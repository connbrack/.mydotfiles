return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-macchiato")
			vim.opt.cursorline = true
			vim.o.winborder = "rounded"
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1E2030" })
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = true,
				RRGGBBAA = false,
				rgb_fn = false,
				hsl_fn = false,
				css = false,
				css_fn = false,
				mode = "background",
			},
		},
	},
}
