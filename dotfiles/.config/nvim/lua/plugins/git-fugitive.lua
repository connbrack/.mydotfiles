return {
  "tpope/vim-fugitive",
    config = function ()
      vim.keymap.set("n", "gc", ":0Gclog<CR>:copen<CR>", {})
    end
}
