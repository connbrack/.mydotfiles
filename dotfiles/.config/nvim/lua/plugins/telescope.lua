return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      telescope.setup {
        defaults = {
          file_ignore_patterns = {
            ".git",
            "node_modules",
            "__pycache__",
            "venv",
            "build",
          },
        },
        pickers = {
          find_files = {
            hidden = true
          },
          live_grep = {
            additional_args = function(opts)
              return { "--hidden" }
            end
          },
        },
      }
      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<C-l>', builtin.live_grep, {})
    end
  },
}
