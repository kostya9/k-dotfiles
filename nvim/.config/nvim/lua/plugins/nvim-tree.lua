return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
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
	},
}
