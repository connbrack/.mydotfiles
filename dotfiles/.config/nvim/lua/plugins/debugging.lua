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
