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

      filesystem = {
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["Z"] = "expand_all_nodes",
            ["D"] = "delete",
            ["d"] = function(state)
              local inputs = require('neo-tree.ui.inputs')
              local path = state.tree:get_node().path
              local utils = require('neo-tree.utils')
              local _, name = utils.split_path(path)

              local msg = string.format("Are you sure you want to trash '%s'?", name)

              inputs.confirm(msg, function(confirmed)
                if not confirmed then return end

                pcall(function()
                  vim.fn.system({ 'trash', vim.fn.fnameescape(path) })
                  if vim.v.shell_error ~= 0 then
                    msg = 'trash command failed.'
                    vim.notify(msg, vim.log.levels.ERROR, { title = 'Neo-tree' })
                  end
                end)

                require('neo-tree.sources.manager').refresh(state.name)
              end)
            end,

          },
        },
        filtered_items = {
          follow_current_file = true,
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            "node_modules",
            "__pycache__",
            ".venv",
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
