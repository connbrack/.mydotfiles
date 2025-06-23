return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup({})
      lspconfig.pyright.setup({})
      lspconfig.ts_ls.setup({})
      lspconfig.clangd.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.bashls.setup({})

      -- make pretty
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = true,
        float = { source = "always" },
        underline = true,
        update_in_insert = false,
      })

      vim.keymap.set("n", "gl", vim.diagnostic.open_float, {})
      vim.keymap.set("n", "gn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "gx", "<cmd>LspRestart<CR>", {})
      vim.keymap.set("n", "gt", function()
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
      end)
      vim.keymap.set('n', 'gT', function()
        vim.diagnostic[vim.diagnostic.is_enabled() and 'disable' or 'enable']()
      end, { noremap = true, silent = true })

      local opts = { silent = true }
      vim.keymap.set("n", "gd", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", opts) -- show lsp definitions
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", opts)
      vim.keymap.set("n", "ga", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
      vim.keymap.set('n', '[=', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
      vim.keymap.set('n', ']=', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })


      -- vim.api.nvim_create_user_command("Format", function() vim.cmd [[lua vim.lsp.buf.format()]] end, {})
    end
  },
  {
    'stevearc/conform.nvim',
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          bash = { "shfmt" },
          python = { "autopep8" },
          rust = { "rustfmt" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          json = { "jq" },
        },
      })

      vim.keymap.set({ "n", "v" }, "gf", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range" })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end
  }
}
