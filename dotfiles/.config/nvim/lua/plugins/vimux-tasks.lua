return {
  {
    'orrors/vimux-tasks',
    dependencies = {
      'preservim/vimux',
      'junegunn/fzf',
      'junegunn/fzf.vim'
    },
    config = function()
      vim.keymap.set('n', '<leader>rt', ':w | VimuxTasks<CR>', {})
    end
  }
}
