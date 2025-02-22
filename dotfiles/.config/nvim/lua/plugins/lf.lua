return {
  {
    'ptzz/lf.vim',
    dependencies = {
      'voldikss/vim-floaterm'
    },
    config = function ()
      vim.cmd("let g:lf_map_keys = 0")
      vim.keymap.set("n", "<leader>fc", ":Lf<CR>", {})
      vim.keymap.set("n", "<leader>fl", ":LfWorkingDirectory<CR>", {})
    end
  }
}

