return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
		"nvim-tree/nvim-web-devicons" -- Recommended but not required. Icons in discussion tree.
	},
	enabled = false,
	build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
	config = function()
		require("gitlab").setup({
			debug = {
				request=true,
				response=true,
				gitlab_request=true,
				gitlab_response=true,
			},
			log_path = "D:/gitlab.nvim.log"

		})
	end,
}
