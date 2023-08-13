vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- This unsets the "last search pattern" register by hitting return
vim.keymap.set({ "n", "v" }, "<CR>", ":nohlsearch<CR><CR>", { silent = true })
