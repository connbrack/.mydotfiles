return {
  "mfussenegger/nvim-dap",
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap-python',
    'nvim-neotest/nvim-nio'
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    require("dap-python").setup("~/.local/share/nvim/python-env/bin/python")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end

    -- use Esc to close the dap-float window type
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dap-float",
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>close!<CR>", { noremap = true, silent = true })
      end
    })

    vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<leader>dc', dap.continue, {})
    vim.keymap.set('n', '<leader>ds', dap.terminate, {})
    vim.keymap.set('n', '<leader>dn', dap.step_into, {})
    vim.keymap.set('n', '<leader>dr', dap.restart, {})
    vim.keymap.set('n', '<leader>du', dapui.toggle, {})
    vim.keymap.set('n', '<leader>di', require('dap.ui.widgets').hover, {})

    -- dap.configurations.python = {
    --   {
    --     type = 'python',
    --     request = 'launch',
    --     name = "Launch file",
    --     program = "${file}",
    --     console = 'integratedTerminal',
    --     cwd = '${workspaceFolder}',
    --   },
    -- }
  end
}
