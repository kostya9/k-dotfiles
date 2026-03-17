return {
	{
		'seblyng/roslyn.nvim',
		event = 'VeryLazy',
		enabled = true,
		ft = { 'cs', 'razor', 'cshtml' },
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {
			-- Filewatching mode
			-- "auto": default behavior
			-- "roslyn": use roslyn's file watching
			-- "off": disable file watching (use if you have performance issues)
			filewatching = 'auto',

			-- Whether to look for solution files in parent directories
			broad_search = false,

			-- Whether to lock the solution target after first attach
			lock_target = false,

			-- Silent mode for initialization notifications
			silent = false,
		},
		config = function(_, opts)
			-- Configure LSP settings using vim.lsp.config API
			vim.lsp.config("roslyn", {
				on_attach = function(client, bufnr)
					require "lspattach" (client, bufnr)
					vim.notify("Roslyn LSP attached", "info")
				end,
				capabilities = require('lspcapabilities'),
				settings = {
					['csharp|inlay_hints'] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					['csharp|code_lens'] = {
						dotnet_enable_references_code_lens = true,
					},
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "fullSolution",
						dotnet_compiler_diagnostics_scope = "fullSolution",
					},
					['csharp|completion'] = {
						dotnet_show_completion_items_from_unimported_namespaces = true,
					},
				},
			})

			-- Setup roslyn with opts
			require("roslyn").setup(opts)

			-- Auto-refresh code lens
			vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "LspAttach" }, {
				pattern = "*.cs",
				callback = function()
					vim.lsp.codelens.refresh({ bufnr = 0 })
				end,
			})
		end,
	},
}
