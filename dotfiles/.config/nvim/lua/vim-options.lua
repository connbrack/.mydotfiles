vim.cmd("set expandtab")

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = " "

vim.cmd("set modeline")
vim.cmd("inoremap jj <ESC>")
vim.cmd("set tabstop=2")

-- spelling
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- "arrow" navigation
vim.cmd("nnoremap <C-h> <C-o>")
vim.cmd("nnoremap <C-l> <C-i>")

-- Sick backspace 
vim.cmd("nnoremap <silent> <backspace> :noh<CR>:pc<CR>:cclose<CR>")
-- Quick fix navigation
vim.cmd("noremap <C-]> :cnext<CR>")
vim.cmd("noremap <C-[> :cprevious<CR>")

-- tab hot keys
vim.cmd("nnoremap <leader>tc :tabnew<CR>")
vim.cmd("nnoremap <leader>tn :tabnext<CR>")
vim.cmd("nnoremap <leader>tp :tabprevious<CR>")

-- Moving with alt!
vim.keymap.set("n", "<A-l>", '<C-w>l')
vim.keymap.set("n", "<A-k>", '<C-w>k')
vim.keymap.set("n", "<A-j>", '<C-w>j')
vim.keymap.set("n", "<A-h>", '<C-w>h')
vim.keymap.set("n", "<A-v>", '<C-w>v')
vim.keymap.set("n", "<A-s>", '<C-w>s')
vim.keymap.set("n", "<A-c>", '<C-w>q')

-- cool nav stuff
vim.keymap.set("n", "<leader>tr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.o.relativenumber = false
vim.o.number = true


-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent. See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Force shift width of 2
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.bo.shiftwidth = 2
  end,
})
