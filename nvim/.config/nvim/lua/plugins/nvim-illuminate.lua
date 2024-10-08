return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			highlight_on = "cursor_hold",
			hi_parameter = "Search",
			hi_byrehighlight = "Visual",
			hi_blacklist = { "NvimTree" },
			under_cursor = false,
			providers = { "treesitter", "regex" },
		})
	end
}
