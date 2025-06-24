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
    require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end

    vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, { desc = 'DAP - Toggle breakpoint' })
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'DAP - Start/Continue debugging' })
    vim.keymap.set('n', '<leader>ds', dap.terminate, { desc = 'DAP - Terminate debugging session' })
    vim.keymap.set('n', '<leader>dn', dap.step_into, { desc = 'DAP - Step into' })
    vim.keymap.set('n', '<leader>dr', dap.restart, { desc = 'DAP - Restart debugging session' })
    vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'DAP - Toggle debug UI' })
    vim.keymap.set('n', '<leader>di', require('dap.ui.widgets').hover, { desc = 'DAP - Inspect variable (hover)' })


    -- *******************************************
    -- ************** PYTHON *********************
    -- *******************************************

    dap.configurations.python = {
      {
        name = "File",
        type = "python",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        justMyCode = true,
        console = "integratedTerminal",
      },
      {
        name = "File:args",
        type = "python",
        request = "launch",
        program = "${file}",
        args = function()
          local input = vim.fn.input('Arguments: ')
          return vim.fn.split(input, " ", true)
        end,
        cwd = vim.fn.getcwd(),
        justMyCode = true,
        console = "integratedTerminal",
      },
      {
        name = "Module",
        type = "python",
        request = "launch",
        module = function()
          return vim.fn.input('Module name (e.g. path.to.module): ')
        end,
        args = function()
          local input = vim.fn.input('Arguments: ')
          return vim.fn.split(input, " ", true)
        end,
        cwd = vim.fn.getcwd(),
        justMyCode = true,
        console = "integratedTerminal",
      },
      {
        type = 'python',
        request = 'launch',
        name = "Debug pytest method",
        module = 'pytest',
        args = { "${file}" },
        justMyCode = false,
      },
    }
  end
}
