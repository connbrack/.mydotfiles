vim.cmd("set expandtab")
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = " "

vim.cmd("set modeline")
vim.cmd("inoremap jj <ESC>")

-- spelling
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- "arrow" navigation
vim.cmd("nnoremap <C-h> <C-o>")
vim.cmd("nnoremap <C-l> <C-i>")

-- xdg open
vim.api.nvim_create_user_command("XdgOpen",
  function() vim.fn.jobstart({ "xdg-open", vim.fn.expand("%:p") }, { detach = true }) end, {})

-- Sick backspace
vim.keymap.set('n', '<backspace>', ':noh<CR>:pc<CR>:cclose<CR>', { noremap = true, silent = true })

-- Quick fix navigation
vim.keymap.set('n', ']c', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', ']@', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '[c', ':cprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '[@', ':cprevious<CR>', { noremap = true, silent = true })

-- tab hot keys
vim.keymap.set('n', '<C-w>c', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-w>n', ':tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-w>p', ':tabprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-w>z', ':tab split<CR>', { noremap = true, silent = true })

-- Moving with alt!
vim.keymap.set("n", "<A-l>", '<C-w>l')
vim.keymap.set("n", "<A-k>", '<C-w>k')
vim.keymap.set("n", "<A-j>", '<C-w>j')
vim.keymap.set("n", "<A-h>", '<C-w>h')
vim.keymap.set("n", "<A-v>", '<C-w>v')
vim.keymap.set("n", "<A-s>", '<C-w>s')
vim.keymap.set("n", "<A-c>", '<C-w>q')

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.o.relativenumber = true
vim.keymap.set('n', ',or', function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = 'Toggle relative number' })
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

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps

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

-- vim.bo.tabstop = 4
-- vim.bo.shiftwidth = 4
-- vim.bo.softtabstop = 4

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "c", "java", "rust" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "html", "css", "ruby", "lua" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})
