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
            ".git",
            "node_modules",
            "__pycache__",
            "venv",
            "build",
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            ".env",
          },
          never_show = {
            ".git"
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
