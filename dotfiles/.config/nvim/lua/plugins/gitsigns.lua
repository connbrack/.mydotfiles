return {
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require("gitsigns").setup()

      vim.keymap.set("n", "gp", ":Gitsigns preview_hunk<CR>", {})
      vim.keymap.set("n", "gu", ":Gitsigns reset_hunk<CR>", {})
      vim.keymap.set("n", "]g", ":Gitsigns next_hunk<CR>", {})
      vim.keymap.set("n", "]*", ":Gitsigns next_hunk<CR>", {})
      vim.keymap.set("n", "[g", ":Gitsigns prev_hunk<CR>", {})
      vim.keymap.set("n", "[*", ":Gitsigns prev_hunk<CR>", {})
    end
  }
}

