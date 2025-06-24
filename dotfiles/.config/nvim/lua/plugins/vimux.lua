return {
  {
    'preservim/vimux',
    config = function()
      vim.keymap.set('n', '<leader>r', ':VimuxRunLastCommand<CR>', { desc = 'Vimux - Run last command' })
      vim.keymap.set('n', '<leader>k', ':VimuxInterruptRunner<CR>', { desc = 'Vimux - Interrupt current command' })
      vim.keymap.set('n', '<leader>c', ':VimuxPromptCommand<CR>', { desc = 'Vimux - Prompt to run command' })
    end
  },
}
