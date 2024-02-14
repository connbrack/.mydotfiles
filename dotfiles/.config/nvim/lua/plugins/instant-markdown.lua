return {
  {
    'instant-markdown/vim-instant-markdown',
    config = function()
      vim.cmd("filetype plugin on")
      vim.cmd("let g:instant_markdown_theme = 'dark'")
    end
  }
}

