return {
  {
    "carbon-steel/detour.nvim",
    config = function()
      require("detour").setup()
      vim.keymap.set('n', '<c-w><enter>', ":Detour<cr>")
      vim.keymap.set('n', '<c-w>.', ":DetourCurrentWindow<cr>")


      -- Oil
      vim.keymap.set("n", "<leader>fo", function()
        local popup_id = require("detour").Detour()
        if not popup_id then
          return
        end

        vim.cmd.enew()
        vim.cmd("Oil")
        vim.wo[popup_id].signcolumn = "no"
      end)

    end
  },
}
