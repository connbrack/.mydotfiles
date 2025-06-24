return {
  "tpope/vim-fugitive",
    config = function ()
      vim.keymap.set("n", "gg", ":0Gclog<CR>:copen<CR>", {})
    end
}
