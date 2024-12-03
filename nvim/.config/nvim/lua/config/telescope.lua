local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ hidden = true }) end, {})
vim.keymap.set('n', '<leader>pp', function() builtin.lsp_workspace_symbols({}) end, {})
-- Add keymap for Ctrl-p
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('v', '<leader>ps', function()
	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getpos(".")
	local mode = vim.fn.mode()
	local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })
	builtin.grep_string({ search = lines[0] })
end)
vim.keymap.set('n', '<leader>pd', function()
	local diagnostic_types = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN }
	builtin.diagnostics({ severity = diagnostic_types })
end)
-- Add help tags
vim.keymap.set('n', '<leader>vh', function()
	builtin.help_tags()
end)

vim.keymap.set('n', 'gu', function()
	require('telescope.builtin').lsp_references({ include_declaration = false })
end)

require('telescope').load_extension('dap')
