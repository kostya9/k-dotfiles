return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = true,
		config = false,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		config = true,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				"lazy.nvim",
				"LazyVim",
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		config = function()
			local cmp = require('cmp')

			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				sources = {
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
				    { name = 'render-markdown' },
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<C-c>'] = cmp.mapping.complete(),
					['<Enter>'] = cmp.mapping.confirm(cmp_select),
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					["<Tab>"] = cmp.mapping(function(fallback)
						if require("copilot.suggestion").is_visible() then
							require("copilot.suggestion").accept()
						elseif cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				}),
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},


			})
		end
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require('mason-tool-installer').setup({
				ensure_installed = {
					-- "omnisharp",
					-- "csharp-language-server",
					"powershell_es",
					"lua_ls",
					"stylua",
					"pyright",
					"ruff",
					"rzls",
					"roslyn",
					"html-lsp"
				},
				run_on_start = true,
			})
		end
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{
				'williamboman/mason.nvim',
				opts = {
					registries = {
						'github:mason-org/mason-registry',
						'github:crashdummyy/mason-registry',
					},
				}
			},
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'ckipp01/stylua-nvim' },
			{ 'Decodetalkers/csharpls-extended-lsp.nvim' },
			--			{ 'jlcrochet/vim-razor' },
			{ 'jmbuhr/otter.nvim' },
		},
		config = function()
			local lsp_zero = require('lsp-zero')

			-- lsp_attach is where you enable features that only work
			-- if there is a language server active in the file
			local lsp_attach = require('lspattach')
			vim.diagnostic.config {
				update_in_insert = true,

				underline = {
					severity = {
						-- Disable underlines for INFO and HINT
						min = vim.diagnostic.severity.WARN
					}
				},
				virtual_text = {
					severity = {
						-- Disable underlines for INFO and HINT
						min = vim.diagnostic.severity.WARN
					}
				},
				signs = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			}
			-- Customize diagnostic signs
			local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = "ⓘ " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
			capabilities = require('lspcapabilities')
			lsp_zero.extend_lspconfig({
				sign_text = true,
				lsp_attach = lsp_attach,
				capabilities = capabilities,
			})
			require('mason-lspconfig').setup({
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,
					omnisharp = function()
						require('lspconfig').omnisharp.setup({
							-- Enables support for reading code style, naming convention and analyzer
							-- settings from .editorconfig.
							enable_editor_config_support = true,
							enable_editorconfig_support = true,

							-- If true, MSBuild project system will only load projects for files that
							-- were opened in the editor. This setting is useful for big C# codebases
							-- and allows for faster initialization of code navigation features only
							-- for projects that are relevant to code that is being edited. With this
							-- setting enabled OmniSharp may load fewer projects and may thus display
							-- incomplete reference lists for symbols.
							enable_ms_build_load_projects_on_demand = false,

							-- Enables support for roslyn analyzers, code fixes and rulesets.
							enable_roslyn_analyzers = true,

							-- Enables support for roslyn analyzers, code fixes and rulesets.
							enable_analyzers_support = true,

							-- Specifies whether 'using' directives should be grouped and sorted during
							-- document formatting.
							organize_imports_on_format = false,

							-- Specifies whether to include preview versions of the .NET SDK when
							-- determining which version to use for project loading.
							sdk_include_prereleases = true,

							enable_decompilation_support = true,

							-- Enables support for showing unimported types and unimported extension
							-- methods in completion lists. When committed, the appropriate using
							-- directive will be added at the top of the current file. This option can
							-- have a negative impact on initial completion responsiveness,
							-- particularly for the first few completion sessions after opening a
							-- solution.
							enable_import_completion = true,

							-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
							-- true
							analyze_open_documents_only = false,

							roslyn_extensions_options_inlay_hints_options_enable_for_types = true,
							settings = {
								FormattingOptions = {
									EnableEditorConfigSupport = true
								},
								RenameOptions = {
									RenameInComments = true,
									RenameInStrings  = true,
									RenameOverloads  = true
								},
								RoslynExtensionsOptions = {
									EnableAnalyzersSupport = true,
									EnableDecompilationSupport = true,
									EnableImportCompletion = true,
									locationPaths = {}
								},
								msbuild = {
									EnablePackageAutoRestore = true,
									AutomaticWorkspaceInit = true,
									LoadProjectsOnDemand = false,
								},
								fileOptions = {
									systemExcludeSearchPatterns = {
										"**/node_modules/**/*",
										"**/bin/**/*",
										"**/obj/**/*",
										"**/node_modules/**/*"
									}
								}
							},
						})
					end,
					csharp_ls = function()
						local config = {
							handlers = {
								["textDocument/definition"] = require(
									'csharpls_extended').handler,
								["textDocument/typeDefinition"] = require(
									'csharpls_extended').handler,
							},
						}
						require 'lspconfig'.csharp_ls.setup(config)
					end,
					lua_ls = function()
						require('lspconfig').lua_ls.setup({
							settings = {
								Lua = {
									format = {
										enable = true,
										-- Put format options here
										-- NOTE: the value should be STRING!!
										defaultConfig = {
											indent_style = "space",
											indent_size = "2",
										}
									}
								}
							},
						})
					end,
				}
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local function toSnakeCase(str)
						return string.gsub(str, "%s*[- ]%s*", "_")
					end

				end,
			})
		end
	}
}
