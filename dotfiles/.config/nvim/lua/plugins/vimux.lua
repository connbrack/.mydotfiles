return {
  {
    'preservim/vimux',
    config = function()
      vim.keymap.set('n', '<leader>rr', ':VimuxRunLastCommand<CR>', {})
      vim.keymap.set('n', '<leader>rk', ':VimuxInterruptRunner<CR>', {})
      vim.keymap.set('n', '<leader>rc', ':VimuxPromptCommand<CR>', {})
    end
  },
}
