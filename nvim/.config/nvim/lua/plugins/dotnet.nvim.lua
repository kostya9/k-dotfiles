return {
	"MoaidHathot/dotnet.nvim",
	cmd = "DotnetUI",
	opts = {},
	config = function()
		require("dotnet").setup({})

		vim.keymap.set({ "n" }, "<leader>dtp", "<cmd>DotnetUI project package add<CR>", { noremap = true })
	end,

}

