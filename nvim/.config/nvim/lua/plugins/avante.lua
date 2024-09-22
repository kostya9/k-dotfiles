return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		-- add any opts here
		provider = "claude",
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
				local keys = {
					['tab']      = vim.api.nvim_replace_termcodes('<Tab>', true, true, true),
					['ctrl-y']   = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
					['ctrl-tab'] = vim.api.nvim_replace_termcodes('<C-Tab>', true, true, true),
				}
				_G.tab_action = function()
					if vim.fn.pumvisible() ~= 0 then
						return keys['ctrl-y']
					elseif require("copilot.suggestion").is_visible() then
						require("copilot.suggestion").accept()
						return
					else
						return keys['tab']
					end
				end
				vim.keymap.set('i', '<Tab>', 'v:lua._G.tab_action()', { expr = true })
				require("copilot").setup({
					suggestion = {
						auto_trigger = true

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
