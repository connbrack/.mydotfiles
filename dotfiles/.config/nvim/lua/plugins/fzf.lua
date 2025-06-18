return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    local opts = { noremap = true, silent = true }

    -- Normal mode mappings
    vim.keymap.set('n', '<leader>F', ':FzfLua<CR>', opts)
    vim.keymap.set('n', '<leader>R', ':FzfLua resume<CR>', opts)
    -- vim.keymap.set('n', '<leader>p', function()
    --   if vim.fn['fugitive#Head']() ~= '' then
  --     vim.cmd('FzfLua git_files')
    --   else
    --     vim.cmd('FzfLua files')
    --   end
    -- end, opts)
    vim.keymap.set('n', '<leader>p', ':FzfLua files<CR>', opts)
    vim.keymap.set('n', '<leader>zb', ':FzfLua buffers<CR>', opts)
    vim.keymap.set('n', '<leader>zl', ':FzfLua lines<CR>', opts)
    vim.keymap.set('n', '<leader>f', ':FzfLua live_grep<CR>', opts)
    vim.keymap.set('n', '<leader>/', ':FzfLua search_history<CR>', opts)
    vim.keymap.set('n', '<leader>:', ':FzfLua command_history<CR>', opts)
    vim.keymap.set('n', '<leader>zm', ':FzfLua keymaps<CR>', opts)
    vim.keymap.set('n', '<leader>zj', ':FzfLua jumps<CR>', opts)
    vim.keymap.set('n', '<leader>zc', ':FzfLua commands<CR>', opts)

    -- Visual mode mappings
    vim.keymap.set('v', '<leader>f', ':FzfLua grep_visual<CR>', opts)
    vim.keymap.set('v', '<leader>gc', ':FzfLua git_bcommits<CR>', opts)

    -- Git-related mappings (normal mode)
    vim.keymap.set('n', '<leader>gb', ':FzfLua git_branches<CR>', opts)
    vim.keymap.set('n', '<leader>gt', ':FzfLua git_tags<CR>', opts)
    vim.keymap.set('n', '<leader>gc', ':FzfLua git_bcommits<CR>', opts)
    vim.keymap.set('n', '<leader>gC', ':FzfLua git_commits<CR>', opts)


    local fzf_lua = require("fzf-lua")
    local actions = fzf_lua.actions
    fzf_lua.setup({

      -- fzf_bin = "fzf-tmux",
      -- fzf_tmux_opts = { ["-p"] = "90%,70%" },
      fzf_opts = {
        ["--border"]  = "rounded",
        ['--info']    = false,
        ["--layout"]  = false,
        ["--tmux"]    = "center,90%,70%",
        ["--history"] = vim.fn.stdpath("data") .. '/fzf-lua-history',
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
      grep = {
        winopts = { preview = { hidden = true } }
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
