local function semantic_tokens(client)
	-- NOTE: Super hacky... Don't know if I like that we set a random variable on the client
	-- Seems to work though
	if client.is_hacked then
		return
	end


	client.is_hacked = true

	-- let the runtime know the server can do semanticTokens/full now
	client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
		semanticTokensProvider = {
			full = true,
		},
	})

	-- monkey patch the request proxy
	local request_inner = client.request
	client.request = function(method, params, handler, req_bufnr)
		if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
			return request_inner(method, params, handler)
		end

		local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
		local line_count = vim.api.nvim_buf_line_count(target_bufnr)
		local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1,
			line_count, true)[1]

		return request_inner("textDocument/semanticTokens/range", {
			textDocument = params.textDocument,
			range = {
				["start"] = {
					line = 0,
					character = 0,
				},
				["end"] = {
					line = line_count - 1,
					character = string.len(last_line) - 1,
				},
			},
		}, handler, req_bufnr)
	end
end

local lsp_attach = function(client, bufnr)
	if client.name == 'omnisharp' then
		-- require('otter').activate({ 'html', 'css', 'javascript', 'typescript', 'csharp' })
	end

	-- semantic_tokens(client)
	local opts = { buffer = bufnr }

	if client.name == 'omnisharp' then
		vim.keymap.set('n', 'gd', '<cmd>lua require(\'omnisharp_extended\').lsp_definition()<cr>', opts)
		vim.keymap.set('n', 'gi', '<cmd>lua require(\'omnisharp_extended\').lsp_implementation()<cr>', opts)
		vim.keymap.set('n', 'gu', '<cmd>lua require(\'omnisharp_extended\').telescope_lsp_references({ include_declaration = false })<cr>', opts)
	else
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	end

	vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
	vim.keymap.set('n', 'gp', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
	vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
		opts)
	vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	vim.keymap.set('n', '<leader>f', function()
		vim.lsp.buf.format()
	end, { silent = true, buffer = bufnr })
	vim.keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	vim.keymap.set('n', 'L', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
	vim.keymap.set({ 'n', 'v' }, '<C-a>', vim.lsp.buf.code_action,
		{ buffer = bufnr, desc = "Code actions" })
end


return lsp_attach
