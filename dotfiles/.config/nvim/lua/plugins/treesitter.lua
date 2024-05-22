return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = { 'vim', 'vimdoc', 'query', 'c', 'cpp', 'go', 'lua', 'python', 'javascript', 'rust', 'typescript', 'cmake' },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
