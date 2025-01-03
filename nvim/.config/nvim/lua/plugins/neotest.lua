return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet",
		"nvim-neotest/neotest-python",
	},
	lazy = true,
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-dotnet")({
					dap = {
						-- Extra arguments for nvim-dap configuration
						-- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
						args = { justMyCode = false },
						-- Enter the name of your dap adapter, the default value is netcoredbg
						adapter_name = "coreclr"
					},

					dotnet_additional_args = {
						"-c Debug"
					},
				}),
				require("neotest-python")({
					runner = "unittest",
				})
			},
			status = { virtual_text = true },
			output = { open_on_run = true },
			-- enable logs
			log_level = vim.log.levels.DEBUG,
		})
	end,
	keys = {
		{ "<leader>t",  "",                                                                                 desc = "+test" },
		{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
		{ "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files" },
		{ "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
		{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                    desc = "Debug Nearest" },
		{ "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last" },
		{ "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
		{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
		{ "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
		{ "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop" },
		{ "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "Toggle Watch" },
	},
}
