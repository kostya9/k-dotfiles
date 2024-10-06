local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-h>', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<C-l>', '<Cmd>BufferNext<CR>', opts)
vim.keymap.set('n', '<C-q>', '<Cmd>BufferClose<CR>', opts)
vim.keymap.set('n', '<C-a><C-q>', '<Cmd>BufferCloseAllButCurrent<CR>', opts)
vim.keymap.set('n', '<leader>q', '<Cmd>BufferCloseAllButCurrent<CR>', opts)

