local o = vim.opt

o.mouse = 'a'

o.clipboard = 'unnamedplus'
o.undofile = true
o.undolevels = 10000

--vim.opt.breakindent = true
o.smartindent = true
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.smarttab = true
o.tabstop = 8

o.ignorecase = true
o.smartcase = true

o.list = true
o.number = true
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true
o.showtabline = 2
o.showmode = false
o.ruler = false
o.wrap = false

o.updatetime = 250
o.timeoutlen = 300
--o.completeopt = 'menu,menuone,noselect'

vim.cmd.colorscheme 'catppuccin'

-- [[ Keymaps ]]
local k = vim.keymap
k.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
k.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
k.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
k.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
k.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
