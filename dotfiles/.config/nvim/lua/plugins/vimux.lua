return {
  {
    'preservim/vimux',
    config = function()
      vim.keymap.set('n', ',r', ':VimuxRunLastCommand<CR>', { desc = 'Vimux - Run last command' })
      vim.keymap.set('n', ',k', ':VimuxInterruptRunner<CR>', { desc = 'Vimux - Interrupt current command' })
      vim.keymap.set('n', ',c', ':VimuxPromptCommand<CR>', { desc = 'Vimux - Prompt to run command' })
    end
  },
}
