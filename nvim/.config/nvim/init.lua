
vim.api.nvim_set_option("clipboard","unnamed")

vim.opt.relativenumber = true
vim.opt.nu = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.g.mapleader = " "
vim.g.encoding = "UTF-8"

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.g.nvim_tree_quit_on_open = 0 -- this doesn't play well with barbar

-- for avante
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

require("config.lazy")
require("config.rose-pine")
require("config.telescope")
require("config.barbar")
require("config.nvim-tree")
require("config.luasnip")

