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
	if client.name == 'roslyn' then
		local otter = require('otter')
		if not otter.is_active then
			otter.activate({ 'html', 'css', 'javascript', 'typescript', 'razor' })
		end
	end

	-- semantic_tokens(client)
	local opts = { buffer = bufnr }

	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
	vim.keymap.set('n', 'ge', function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, { buffer = bufnr, desc = "Next error" })
	vim.keymap.set('n', 'gp', function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { buffer = bufnr, desc = "Previous error" })
	vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
	vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
	vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "Format document" })
	vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { silent = true, buffer = bufnr, desc = "Format document" })
	vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
	vim.keymap.set('n', 'L', vim.diagnostic.open_float, { buffer = bufnr, desc = "Show diagnostics" })
	vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
end


return lsp_attach
