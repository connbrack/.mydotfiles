return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    -- Normal mode mappings
    vim.keymap.set('n', '<leader>z', ':FzfLua<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Open main menu' })
    vim.keymap.set('n', '<leader>R', ':FzfLua resume<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Resume last picker' })
    vim.keymap.set('n', '<leader>p', ':FzfLua files<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Search files' })
    vim.keymap.set('n', '<leader>b', ':FzfLua buffers<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - List open buffers' })
    vim.keymap.set('n', '<leader>f', ':FzfLua live_grep<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Live grep project' })
    vim.keymap.set('n', '<leader>/', ':FzfLua search_history<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Search history' })
    vim.keymap.set('n', '<leader>:', ':FzfLua command_history<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Command history' })
    vim.keymap.set('n', '<leader>m', ':FzfLua keymaps<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Search keymaps' })
    vim.keymap.set('v', '<leader>f', ':FzfLua grep_visual<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - Grep selected text' })
    vim.keymap.set('n', 'gb', ':FzfLua git_branches<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - List git branches' })
    vim.keymap.set('n', '<leader>g', ':FzfLua git_bcommits<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - List git commits for current buffer' })
    vim.keymap.set('n', '<leader>G', ':FzfLua git_commits<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - List git commits' })
    vim.keymap.set('n', '<leader>d', ':FzfLua lsp_document_symbols<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - lsp document symbols' })
    vim.keymap.set('n', '<leader>l', ':FzfLua lsp_document_diagnostics<CR>',
      { noremap = true, silent = true, desc = 'FzfLua - lsp document diagnostics' })

    local fzf_lua = require("fzf-lua")
    local actions = fzf_lua.actions
    fzf_lua.setup({

      -- fzf_bin = "fzf-tmux",
      -- fzf_tmux_opts = { ["-p"] = "90%,70%" },
      fzf_layout = 'default',
      fzf_opts = {
        ["--border"]  = "rounded",
        ['--info']    = false,
        ["--layout"]  = false,
        ["--tmux"]    = "center,90%,70%",
        ["--history"] = vim.fn.stdpath("data") .. '/fzf-lua-history',
        ["--color"]   = "bg+:#2a2a37,hl+:underline:bold:italic",
      },
      fzf_colors = {
        ["border"] = { "fg", "Comment" },
      },
      file_icon_padding = '',
      winopts = {
        preview = {
          default = "bat",
          border = "border-left",
          layout = "horizontal",
          horizontal = "right:50%",
        }
      },
      keymap = {
        builtin = {
          true,
          -- nvim registers <C-/> as <C-_>, use insert mode
          -- and press <C-v><C-/> should output ^_
          ["<C-_>"] = "toggle-preview",
          ["ctrl-a"] = "toggle-all",
        },
        fzf = {
          true,
          ["ctrl-/"] = "toggle-preview",
          ["ctrl-a"] = "toggle-all",
        },
      },
      actions = {
        files = {
          ["enter"] = actions.file_edit_or_qf,
          ["ctrl-s"] = actions.file_split,
          ["ctrl-v"] = actions.filevsplit,
          ["ctrl-t"] = actions.file_tabedit,
          ["ctrl-q"] = actions.file_sel_to_qf,
        },
      },
      files = {
        file_icons = false, -- show file icons (true|"devicons"|"mini")?
      },
      manpages = { previewer = "man_native" },
      helptags = { previewer = "help_native" },
      lsp = {
        code_actions = {
          previewer = "codeaction_native",
          -- preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
        }
      },
      tags = { previewer = "bat" },
      btags = { previewer = "bat" },
      lines = { _treesitter = false, },
      blines = { _treesitter = false },
      git = {
        files = {
          file_icons = false, -- show file icons (true|"devicons"|"mini")?
        },
        commits = {
          cmd = [[git log --color --pretty=format:'%C(yellow)%h%Creset %C(auto)%d%Creset %s (%Cblue%an%Creset, %cr)' ]],
        },
        bcommits = {
          cmd =
          [[git log --color --pretty=format:'%C(yellow)%h%Creset %C(auto)%d%Creset %s (%Cblue%an%Creset, %cr)' {file}]],
        }
      },
    })
  end
}
