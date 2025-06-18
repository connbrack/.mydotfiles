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

      vim.keymap.set("n", "<leader>l", vim.diagnostic.open_float, {})
      vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {})
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<leader>lx", "<cmd>LspRestart<CR>", {})
      vim.keymap.set("n", "<leader>lt", function()
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
      end)
      vim.keymap.set('n', '<leader>lT', function()
        vim.diagnostic[vim.diagnostic.is_enabled() and 'disable' or 'enable']()
      end, { noremap = true, silent = true })

      local opts = { silent = true }
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
      vim.keymap.set("n", "ga", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})


      -- vim.api.nvim_create_user_command("Format", function() vim.cmd [[lua vim.lsp.buf.format()]] end, {})
    end
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Bash
          require("null-ls").builtins.formatting.shfmt,
          -- Python
          null_ls.builtins.diagnostics.pylint,
          require("none-ls.formatting.autopep8").with({
            extra_args = { "--max-line-length=120", "--indent-size=2" }
          }),
          -- JS
          require("none-ls.diagnostics.eslint"),
          null_ls.builtins.formatting.prettier,
          -- json
          require("none-ls.formatting.jq"),
          null_ls.builtins.formatting.clang_format,
        },
      })
    end
  },
}
