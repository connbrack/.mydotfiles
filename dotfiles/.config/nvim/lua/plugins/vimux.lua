return {
  {
    'preservim/vimux',
    config = function()
      vim.keymap.set('n', '<leader>r', ':VimuxRunLastCommand<CR>', {})
      vim.keymap.set('n', '<leader>k', ':VimuxInterruptRunner<CR>', {})
      vim.keymap.set('n', '<leader>c', ':VimuxPromptCommand<CR>', {})
    end
  },
}
