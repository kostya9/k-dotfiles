return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-dap.nvim' },
	opts =
	{
		defaults = {
			vimgrep_arguments =
			{
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--ignore-file",
				"~/.config/nvim/.ignore",
			}
		}
	}
}
