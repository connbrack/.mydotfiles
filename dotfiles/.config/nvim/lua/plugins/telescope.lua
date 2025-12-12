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
          find_files = {},
          live_grep = {},
        },
      }
      require("telescope").load_extension("ui-select")
    end

  },

  {
    "debugloop/telescope-undo.nvim",
    config = function()
      require("telescope").load_extension("undo")
      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    end

  },
}
