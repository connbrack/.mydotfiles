return {
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
      vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>", {})
      vim.keymap.set("n", "<leader>gl", ":Gitsigns next_hunk<CR>", {})
      vim.keymap.set("n", "<leader>gh", ":Gitsigns prev_hunk<CR>", {})
    end
  }
}

