return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		require("mason-nvim-dap").setup({
			ensure_installed = { "coreclr" }
		})
		local dap = require('dap')
		vim.g.dotnet_build_project = function()
			local default_path = vim.fn.getcwd() .. '/'
			if vim.g['dotnet_last_proj_path'] ~= nil then
				default_path = vim.g['dotnet_last_proj_path']
			end
			local path = vim.fn.input('Path to your *proj file', default_path, 'file')
			vim.g['dotnet_last_proj_path'] = path
			local cmd = 'dotnet build -c Debug ' .. path
			print('')
			print('Cmd to execute: ' .. cmd)
			local f = os.execute(cmd)
			if f == 0 then
				print('\nBuild: ✔️ ')
			else
				print('\nBuild: ❌ (code: ' .. f .. ')')
			end
		end

		vim.g.dotnet_get_dll_path = function()
			local request = function()
				return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
			end

			if vim.g['dotnet_last_dll_path'] == nil then
				vim.g['dotnet_last_dll_path'] = request()
			else
				if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
					vim.g['dotnet_last_dll_path'] = request()
				end
			end

			return vim.g['dotnet_last_dll_path']
		end

		local config = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
						vim.g.dotnet_build_project()
					end
					return vim.g.dotnet_get_dll_path()
				end,
			},
		}
		-- get stdpath data
		local mason_install_dir = vim.fn.stdpath('data') .. '/mason/packages'
		print(mason_install_dir)

		dap.configurations.cs = config
		dap.configurations.fsharp = config

		dap.adapters.coreclr = {
			type = 'executable',
			command = mason_install_dir .. '/netcoredbg/netcoredbg/netcoredbg.exe',
			args = { '--interpreter=vscode' }
		}
	end

}
