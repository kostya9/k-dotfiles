local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ hidden = true }) end, {})
vim.keymap.set('n', '<leader>pp', function() builtin.lsp_workspace_symbols({ }) end, {})
-- Add keymap for Ctrl-p
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
-- Add help tags
vim.keymap.set('n', '<leader>vh', function()
	builtin.help_tags()
end)

vim.keymap.set('n', 'gu', function()
	require('telescope.builtin').lsp_references({include_declaration = false})
end)

require('telescope').load_extension('dap')
