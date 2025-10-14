return {
  {

    "mfussenegger/nvim-dap",
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")

      dap.adapters.lldb = {
        type = "executable",
        command = vim.loop.os_homedir() .. "/.local/share/nvim/mason/packages/codelldb/codelldb",
        name = "lldb",
      }

      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" }
      }

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      vim.keymap.set('n', ',b', dap.toggle_breakpoint, { desc = 'DAP - Toggle breakpoint' })
      vim.keymap.set('n', ',d', dap.continue, { desc = 'DAP - Start/Continue debugging' })
      vim.keymap.set('n', ',s', dap.terminate, { desc = 'DAP - Terminate debugging session' })
      vim.keymap.set('n', ']=', dap.step_into, { desc = 'DAP - Step into' })
      -- vim.keymap.set('n', '<leader>dr', dap.restart, { desc = 'DAP - Restart debugging session' })
      vim.keymap.set('n', ',u', dapui.toggle, { desc = 'DAP - Toggle debug UI' })
      -- vim.keymap.set('n', '<leader>di', require('dap.ui.widgets').hover, { desc = 'DAP - Inspect variable (hover)' })


      -- *******************************************
      -- ************** PYTHON *********************
      -- *******************************************

      dap.configurations.python = {
        {
          name = "File",
          type = "python",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
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

      -- *******************************************
      -- *************++ REACT **+******************
      -- *******************************************

      dap.configurations.javascriptreact = {
        {
          name = "React",
          type = "chrome",
          request = "attach",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}/src"
        }
      }

      dap.configurations.typescriptreact = {
        {
          name = "React",
          type = "chrome",
          request = "attach",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}/src"
        }
      }

      dap.configurations.javascript = {
        {
          name = "React",
          type = "chrome",
          request = "attach",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}/src"
        }
      }

      dap.configurations.typescript = {
        {
          name = "React",
          type = "chrome",
          request = "attach",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}/src"
        }
      }

      -- *******************************************
      -- *************++ RUST **+*******************
      -- *******************************************

      dap.configurations.rust = {
        {
          name = "Run",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.getcwd() .. "/target/debug/c107"
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end
  }
}
