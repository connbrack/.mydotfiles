return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  -- ft = "markdown" -- If you decide to lazy-load anyway

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    vim.keymap.set("n", "<leader>mt", ":Markview toggle<CR>", {})
    vim.keymap.set("n", "<leader>ms", ":Markview splitToggle<CR>", {})

    require('markview').setup({
      preview = enabled,
    })
  end
}
