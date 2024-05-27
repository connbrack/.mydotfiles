return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["Z"] = "expand_all_nodes",
        },
      },
      filesystem = {
        filtered_items = {
          follow_current_file = true,
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_by_name = {
<<<<<<< HEAD
            "node_modules",
            "__pycache__",
            "venv",
=======
            ".git",
            "node_modules",
            "__pycache__",
            ".venv",
>>>>>>> 690fa47a43cc6abf84e6de43ac97b6339962f2ec
            "build",
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            ".env",
          },
<<<<<<< HEAD
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            --".DS_Store",
            --"thumbs.db"
=======
          never_show = {
            ".git"
>>>>>>> 690fa47a43cc6abf84e6de43ac97b6339962f2ec
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
      }
    })
    vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
    vim.keymap.set('n', '<leader>bf', ':Neotree buffers reveal float<CR>', {})
  end
}
