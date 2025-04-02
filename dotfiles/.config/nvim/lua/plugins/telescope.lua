return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      'nvim-telescope/telescope-ui-select.nvim'
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      telescope.setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        },

        defaults = {
          file_ignore_patterns = {
            "%.git",
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
      require("telescope").load_extension("ui-select")

      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
    end

  },

  {
    "debugloop/telescope-undo.nvim",
    config = function()
      require("telescope").load_extension("undo")
      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    end

  },

  {
    "isak102/telescope-git-file-history.nvim",
    dependencies = { "tpope/vim-fugitive" },
    config = function()
      require("telescope").load_extension("git_file_history")
      vim.keymap.set("n", "<leader>gC", "<cmd>Telescope git_file_history<cr>")
    end

  }

}
