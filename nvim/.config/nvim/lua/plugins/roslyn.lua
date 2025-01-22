local capabilities = require('lspcapabilities')
return {
	{
		'seblj/roslyn.nvim',
		event = 'VeryLazy',
		enabled = true,
		dependencies = {
			{
				'tris203/rzls.nvim',
				opts = {
					on_attach = require 'lspattach',
					capabilities = capabilities,
				},
			},
		},
		config = function()
			--- @param client vim.lsp.Client the LSP client
			local function monkey_patch_semantic_tokens(client)
				-- NOTE: Super hacky... Don't know if I like that we set a random variable on
				-- the client Seems to work though ~seblj
				if client.is_hacked then
					return
				end
				client.is_hacked = true

				-- let the runtime know the server can do semanticTokens/full now
				client.server_capabilities =
				    vim.tbl_deep_extend("force", client.server_capabilities, {
					    semanticTokensProvider = {
						    full = true,
					    },
				    })

				-- monkey patch the request proxy
				local request_inner = client.request
				function client:request(method, params, handler, req_bufnr)
					if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
						return request_inner(self, method, params, handler)
					end

					local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
					local line_count = vim.api.nvim_buf_line_count(target_bufnr)
					local last_line = vim.api.nvim_buf_get_lines(
						target_bufnr,
						line_count - 1,
						line_count,
						true
					)[1]

					return request_inner(self, "textDocument/semanticTokens/range", {
						textDocument = params.textDocument,
						range = {
							["start"] = {
								line = 0,
								character = 0,
							},
							["end"] = {
								line = line_count - 1,
								character = string.len(last_line) - 1,
							},
						},
					}, handler, req_bufnr)
				end
			end

			local mason_registry = require "mason-registry"

			--- @type string[]
			local args = {
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			}

			local rzls_package = mason_registry.get_package "rzls"
			if rzls_package:is_installed() then
				local rzls_path = vim.fs.joinpath(rzls_package:get_install_path(), "libexec")
				table.insert(
					args,
					"--razorSourceGenerator="
					.. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll")
				)
				table.insert(
					args,
					"--razorDesignTimePath="
					.. vim.fs.joinpath(
						rzls_path,
						"Targets",
						"Microsoft.NET.Sdk.Razor.DesignTime.targets"
					)
				)
			end

			--- @type RoslynNvimConfig
			local config = {
				args = args,
				config = {
				    filetypes = { 'razor' },
					handlers = require "rzls.roslyn_handlers",
					on_attach = function(client, bufnr)
						require "lspattach" (client, bufnr)

						monkey_patch_semantic_tokens(client)
					end,

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
					},
				},
				filewatching = false,
			}

			local roslyn_package = mason_registry.get_package "roslyn"
			if roslyn_package:is_installed() then
				config.exe = {
					"dotnet",
					vim.fs.joinpath(
						roslyn_package:get_install_path(),
						"libexec",
						"Microsoft.CodeAnalysis.LanguageServer.dll"
					),
				}
			end

			require("roslyn").setup(config)
		end,
	},
}
