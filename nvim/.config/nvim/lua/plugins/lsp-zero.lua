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
				   -- { name = 'supermaven' },
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'render-markdown' },
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<Enter>'] = cmp.mapping.confirm(cmp_select),
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
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
					"roslyn",
					"html-lsp"
				},
				run_on_start = true,
			})
		end
	},
	{
		'jmbuhr/otter.nvim',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
		opts = {},
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
						'github:Crashdummyy/mason-registry',
					},
				}
			},
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'ckipp01/stylua-nvim' },
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
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = "󰌵 ",
						[vim.diagnostic.severity.INFO] = "ⓘ ",
					},
				},
			})
			local capabilities = require('lspcapabilities')
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

			end
	}
}
