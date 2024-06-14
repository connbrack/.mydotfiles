return {
  {
    'preservim/vimux',
    config = function()
      vim.keymap.set('n', '<leader>rr', ':w | VimuxRunLastCommand<CR>', {})
      vim.keymap.set('n', '<leader>rk', ':VimuxInterruptRunner<CR>', {})
      vim.keymap.set('n', '<leader>rc', ':VimuxPromptCommand<CR>', {})
    end
  },
}
