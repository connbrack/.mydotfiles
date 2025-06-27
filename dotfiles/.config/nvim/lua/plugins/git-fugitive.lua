return {
  "tpope/vim-fugitive",
    config = function ()
      vim.keymap.set("n", "gC", ":0Gclog<CR>:copen<CR>", {})
    end
}
