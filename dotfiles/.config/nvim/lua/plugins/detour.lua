return {
  {
    "carbon-steel/detour.nvim",
    config = function()
      require("detour").setup()
      vim.keymap.set('n', '<C-w><enter>', ":Detour<cr>")
      vim.keymap.set('n', '<C-w>.', ":DetourCurrentWindow<cr>")
    end
  },
}
