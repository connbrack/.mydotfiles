return {
  {
    'orrors/vimux-tasks',
    dependencies = {
      'preservim/vimux',
      'junegunn/fzf',
      'junegunn/fzf.vim'
    },
    config = function()
      vim.keymap.set('n', '<leader>rj', ':w | VimuxTasks<CR>', {})
    end
  },
  {'GustavoKatel/telescope-asynctasks.nvim',
    dependencies = {
      'orrors/asynctasks.vim',
      'skywind3000/asyncrun.vim',
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
    },
    config = function()
      vim.cmd("let g:asyncrun_open = 6")
      vim.cmd("let g:asynctasks_config_name = '.vim/tasks.ini'")
      vim.cmd("let g:asynctasks_term_pos = 'tmux'")

      vim.keymap.set("n", "<leader>t", ":Telescope asynctasks all<CR>", {})
    end
  },
}
