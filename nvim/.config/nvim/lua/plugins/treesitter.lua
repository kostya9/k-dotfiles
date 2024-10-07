return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
			auto_install = false,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}
