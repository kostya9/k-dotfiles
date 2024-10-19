vim.loader.enable()

vim.api.nvim_set_option("clipboard", "unnamed")

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

vim.opt.splitright = true

vim.opt.shell = "pwsh"
vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellquote = ""
vim.o.shellxquote = ""

vim.opt.pumblend = 0

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.g.nvim_tree_quit_on_open = 0 -- this doesn't play well with barbar

-- for avante
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- on windows, shada files are very annoying (always being locked)
vim.opt.shadafile = "NONE"

-- This unsets the "last search pattern" register by hitting return
vim.keymap.set({ "n", "v" }, "<CR>", ":nohlsearch<CR><CR>", { silent = true })

-- get text from aibot cmd on ctrl-t
vim.keymap.set({ "n", "i" }, "<C-t>", function() AichatGenerateGitCommitMessage() end)

-- close  terminal with <ESC>
vim.api.nvim_set_keymap(  't'  ,  '<ESC>'  ,  '<C-\\><C-n>'  ,  {noremap = true}  )
vim.api.nvim_set_keymap(  'n'  ,  '<leader>ot'  ,  ':sp | terminal<CR>:set nobuflisted<CR>'  ,  {noremap = true}  )
vim.api.nvim_set_keymap(  'n'  ,  '<leader>ovt'  ,  ':vsp | terminal<CR>:set nobuflisted<CR>'  ,  {noremap = true}  )

-- setup global function AibotGetText
_G.AichatGenerateGitCommitMessage = function()
	local diff = vim.fn.system("git --no-pager diff -U6 --cached")

	if diff == "" then
		diff = vim.fn.system("git --no-pager diff -U6 HEAD")
	end

	if diff == "" then
		vim.notify("No changes to commit")
		return
	end

	local branch = vim.fn.system({"git", "rev-parse", "--abbrev-ref", "HEAD"})

	local recentCommits = vim.fn.system({"git", "log", "-n 10", "--pretty=format:'%h %s'"})
	local prompt = [[
Please suggest a single commit messages, given the following diff:

        ```diff
	]] .. diff .. [[
        ```

        **Criteria:**

        1. **Format:** Each commit message must follow the conventional commits format,
        which is `<jira-ticket-code>: <description>`.
        2. **Relevance:** Avoid mentioning a module name unless it's directly relevant
        to the change.
        3. **Enumeration:** List the commit messages from 1 to 10.
        4. **Clarity and Conciseness:** Each message should clearly and concisely convey
        the change made.

	Please consider that the branch you are working on is:
	```
	]] .. branch .. [[
	```

	**If the branch contains JIRA ticket, please include it in the commit message.**
	Examples:
	MISC-2287: add password regex pattern
	PRODUCT-123: add new test cases
	MISC-7792: remove unused imports

        **Otherwise, follow the format below: <type>(<scope>): <description>**
        **Commit Message Examples:**

        - fix(app): add password regex pattern
        - test(unit): add new test cases
        - style: remove unused imports
        - refactor(pages): extract common code to `utils/wait.ts`

        **Recent Commits on Repo for Reference:**

        ```
	]] .. recentCommits .. [[
        ```

        **Output Template**

        Follow this output template and ONLY output raw commit messages without spacing,
        numbers or other decorations.

        fix(app): add password regex pattern
        test(unit): add new test cases
        style: remove unused imports
        refactor(pages): extract common code to `utils/wait.ts`
	MISC-3308: add password regex pattern

        **Instructions:**

        - Take a moment to understand the changes made in the diff.

        - Think about the impact of these changes on the project (e.g., bug fixes, new
        features, performance improvements, code refactoring, documentation updates).
        It's critical to my career you abstract the changes to a higher level and not
        just describe the code changes.

        - Generate commit messages that accurately describe these changes, ensuring they
        are helpful to someone reading the project's history.

        - Remember, a well-crafted commit message can significantly aid in the maintenance
        and understanding of the project over time.

        - If multiple changes are present, make sure you capture them all in each commit
        message.

        Keep in mind you will suggest 10 commit messages. Only 1 will be used. It's
        better to push yourself (esp to synthesize to a higher level) and maybe wrong
        about some of the 10 commits because only one needs to be good. I'm looking
        for your best commit, not the best average commit. It's better to cover more
        scenarios than include a lot of overlap.

        Write your 10 commit messages below in the format shown in Output Template section above.

		]]

	vim.notify("Asking AI for commit message... ")


	-- run aichat command with prompt
	local text = vim.fn.system("aichat ", prompt)

	-- split text by newline
	text = vim.fn.split(text, "\n")

	-- select only the lines that are not empty
	text = vim.fn.filter(text, "v:val != ''")

	print(type(text))
	-- select a single line from the text with telescope plugin
	text = require("telescope.pickers").new({}, {
		prompt_title = "Select a commit message",
		results_title = "Commit Messages",
		finder = require("telescope.finders").new_table {
			results = text,
		},
		attach_mappings = function(prompt_bufnr, map)
			local select_commit = function()
				local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
				require("telescope.actions").close(prompt_bufnr)
				vim.notify("Copied commit message to clipboard " .. selection.value .. "")
				vim.fn.setreg("+", selection.value)
			end

			map("i", "<CR>", select_commit)
			map("n", "<CR>", select_commit)

			return true
		end,
	}):find()
end

-- set file type for Dockerfile-*
vim.api.nvim_command("au BufNewFile,BufRead Dockerfile* set filetype=dockerfile")

require("config.lazy")
require("config.rose-pine")
require("config.telescope")
require("config.barbar")
require("config.nvim-tree")
require("config.luasnip")

-- for some reason shellslash is being reset to true
vim.opt.shellslash = false
vim.defer_fn(function()
	vim.opt.shellslash = false
end, 5000)

