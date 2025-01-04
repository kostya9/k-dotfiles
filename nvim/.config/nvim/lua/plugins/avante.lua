return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = true,
	version = false, -- set this if you want to always pull the latest change
	enable = false,
	opts = {
		-- add any opts here
		provider = "claude",
		windows = {
			ask = {
				floating = true
			}
		}
	},
	build = "pwsh -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
					suggestion = {
						auto_trigger = true,

					},
					filetypes = {
						markdown = true
					}
				})
			end
		}, -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
