return {
  "tpope/vim-fugitive",
    config = function ()
      vim.keymap.set("n", "<leader>gf", ":0Gclog<CR>:copen<CR>", {})
    end
}
