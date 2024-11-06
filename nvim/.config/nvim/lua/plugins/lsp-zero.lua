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
		dependencies = {
			{ 'L3MON4D3/LuaSnip' },
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				sources = {
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
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
					"csharp-language-server",
					"powershell_es",
					"lua_ls",
					"stylua",
					"pyright",
					"ruff-lsp",
					"grammarly-languageserver"
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
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'Hoffs/omnisharp-extended-lsp.nvim' },
			{ 'ckipp01/stylua-nvim' },
			{ 'Decodetalkers/csharpls-extended-lsp.nvim' },
			--			{ 'jlcrochet/vim-razor' },
			{ 'jmbuhr/otter.nvim' }
		},
		config = function()
			local lsp_zero = require('lsp-zero')

			-- lsp_attach is where you enable features that only work
			-- if there is a language server active in the file
			local lsp_attach = function(client, bufnr)
				local opts = { buffer = bufnr }

				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
				vim.keymap.set('n', 'gp', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
					opts)
				vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				vim.keymap.set('n', '<leader>f', function()
					vim.lsp.buf.format()
				end, { silent = true, buffer = bufnr })
				vim.keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
			end
			vim.diagnostic.config { update_in_insert = true }
			lsp_zero.extend_lspconfig({
				sign_text = true,
				lsp_attach = lsp_attach,
				capabilities = require('cmp_nvim_lsp').default_capabilities()
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



							handlers = {
								["textDocument/definition"] = require(
									'omnisharp_extended').handler,
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

					if client.name == 'omnisharp' then
						local tokenModifiers = client.server_capabilities.semanticTokensProvider
						    .legend.tokenModifiers
						for i, v in ipairs(tokenModifiers) do
							tokenModifiers[i] = toSnakeCase(v)
						end
						local tokenTypes = client.server_capabilities.semanticTokensProvider
						    .legend.tokenTypes
						for i, v in ipairs(tokenTypes) do
							tokenTypes[i] = toSnakeCase(v)
						end
					end
				end,
			})
		end
	}
}
