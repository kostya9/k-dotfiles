local function custom_on_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	local preview = require('nvim-tree-preview')

	-- custom mappings
	vim.keymap.set('n', 'gp', api.node.navigate.diagnostics.prev_recursive, opts('Prev diagnostic'))
	vim.keymap.set('n', 'ge', api.node.navigate.diagnostics.next_recursive, opts('Next diagnostic'))
	vim.keymap.set('n', 'K', preview.node_under_cursor, opts 'Preview (Watch)')
	vim.keymap.set('n', '<Esc>', preview.unwatch, opts 'Close Preview/Unwatch')
end

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		'b0o/nvim-tree-preview.lua'
	},
	keys = {
		{ "<leader>nt", ":NvimTreeToggle<CR>",   { noremap = true, silent = true } },
		{ "<leader>nf", ":NvimTreeFindFile<CR>", { noremap = true, silent = true } },
	},
	opts = {
		hijack_unnamed_buffer_when_opening = false,
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		disable_netrw = true,
		hijack_netrw = true,
		hijack_cursor = true,
		update_focused_file = {
			enable = true,
			update_root = {
				enable = false,
			}
		},
		actions = {
			open_file = {
				quit_on_open = true,
			}
		},
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			severity = {
				min = vim.diagnostic.severity.ERROR,
			},
		},
		renderer = {
			full_name = true,
			group_empty = true,
			special_files = {},
			highlight_diagnostics = true,
			symlink_destination = false,
			indent_markers = {
				enable = true,
			},
			icons = {
				git_placement = "signcolumn",
				show = {
					file = true,
					folder = false,
					folder_arrow = true,
					git = true,
				},
			},
		},
		on_attach = custom_on_attach,
	},
}
