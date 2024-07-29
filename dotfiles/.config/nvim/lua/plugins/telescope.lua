return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 
      "nvim-lua/plenary.nvim" ,
      "debugloop/telescope-undo.nvim",
      "isak102/telescope-git-file-history.nvim",
      dependencies = { "tpope/vim-fugitive" }
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      require("telescope").load_extension("undo")
      telescope.setup {
        defaults = {
          file_ignore_patterns = {
            ".git",
            "node_modules",
            "__pycache__",
            ".venv",
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

      require("telescope").load_extension("git_file_history")

      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
      vim.keymap.set("n", "<leader>gC", "<cmd>Telescope git_file_history<cr>")
    end
  },
}
