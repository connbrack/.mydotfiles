return {
  "tpope/vim-fugitive",
    config = function ()
      vim.keymap.set("n", "<leader>c", ":0Gclog<CR>:copen<CR>", {})
    end
}
