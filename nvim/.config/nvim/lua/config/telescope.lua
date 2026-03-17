local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ hidden = true }) end, {})
vim.keymap.set('n', '<leader>pp', function() builtin.lsp_workspace_symbols({}) end, {})
-- Add keymap for Ctrl-p
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ 
		search = vim.fn.input("Grep > "),
		ignore_case = true
	})
end)
vim.keymap.set('v', '<leader>ps', function()
	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getpos(".")
	local mode = vim.fn.mode()
	local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })
	builtin.grep_string({
		search = lines[1],
		ignore_case = true
	})
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

-- Add branch diff command
vim.keymap.set('n', '<leader>gd', function()
	-- Check if Diffview is already open
	local is_diffview_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name:match("DiffviewFiles") or buf_name:match("diffview://") then
			is_diffview_open = true
			break
		end
	end
	
	-- If Diffview is open, close it
	if is_diffview_open then
		vim.cmd('DiffviewClose')
		return
	end
	
	-- Otherwise, open the branch selection
	local actions = require('telescope.actions')
	local actions_set = require('telescope.actions.set')
	local action_state = require('telescope.actions.state')
	
	-- Get the default branch (main or master)
	local default_branch
	
	-- Check if master branch exists
	local master_exists = vim.fn.system("git rev-parse --verify master 2>/dev/null"):match("[^\n\r]+") ~= nil
	-- Check if main branch exists
	local main_exists = vim.fn.system("git rev-parse --verify main 2>/dev/null"):match("[^\n\r]+") ~= nil
	
	-- Use master if it exists, otherwise use main if it exists
	if master_exists then
		default_branch = "master"
	elseif main_exists then
		default_branch = "main"
	else
		-- Fall back to main if neither exists
		default_branch = "main"
	end
		print(default_branch)
	
	-- Check if there are local changes
	local has_local_changes = vim.fn.system("git status --porcelain 2>/dev/null"):match("[^\n\r]+") ~= nil
	
	-- Add a special entry for local changes
	local local_changes = {
		name = "(local changes)",
		value = "",  -- Empty string means show working tree changes
		ordinal = "0",  -- To make it appear at the top
		display = "(local changes)",
	}
	
	builtin.git_branches({
		attach_mappings = function(prompt_bufnr, map)
			-- Add the local changes option at the beginning
			local picker = action_state.get_current_picker(prompt_bufnr)
			table.insert(picker.finder.results, 1, local_changes)
			picker:refresh()
			
			-- If there are local changes, select the local changes option by default
			if has_local_changes then
				vim.notify("Local changes detected", vim.log.levels.INFO)
				-- Move selection to the first item (local changes)
				picker:set_selection(1)
			else
				-- No local changes, find and select the default branch
				for i, entry in ipairs(picker.finder.results) do
					if entry.name == default_branch then
						vim.defer_fn(function()
								actions_set.shift_selection(prompt_bufnr, -i + 1)
						end, 100)
						break
					end
				end
			end
			
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				
				if selection and selection.value == "" then
					-- Show local changes only
					vim.cmd('DiffviewOpen')
				else
					-- If no branch is selected, use the default branch
					local branch = selection and selection.value or default_branch
					
					-- Open Diffview with the selected branch
					vim.cmd('DiffviewOpen ' .. branch)
				end
			end)
			
			-- Add a mapping to use the default branch
			map('i', '<C-d>', function()
				actions.close(prompt_bufnr)
				vim.cmd('DiffviewOpen ' .. default_branch)
			end)
			
			-- Add a mapping to show local changes
			map('i', '<C-l>', function()
				actions.close(prompt_bufnr)
				vim.cmd('DiffviewOpen')
			end)
			
			return true
		end,
	})
end)
