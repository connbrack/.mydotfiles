return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".git"
          end,
        },
        -- float = {
        --   padding = 2,
        --   max_width = 90,
        --   max_height = 0,
        -- },
        -- win_options = {
        --   wrap = true,
        --   winblend = 0,
        -- },
        use_default_keymaps = false,
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["gv"] = { "actions.select", opts = { vertical = true } },
          ["gs"] = { "actions.select", opts = { horizontal = true } },
          ["gt"] = { "actions.select", opts = { tab = true } },
          ["gp"] = "actions.preview",
          ["q"] = { "actions.close", mode = "n" },
          ["gr"] = "actions.refresh",
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["zs"] = { "actions.change_sort", mode = "n" },
          ["go"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
        },
      })
    end,

    vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open parent directory" }),

  },
}
