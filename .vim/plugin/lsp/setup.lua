if vim.fn.has('nvim') then
	-- ok
else
	return
end

function setup()
	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		-- See `:help vim.lsp.*`
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
		local opts = { noremap = true, silent = true }

		--buf_set_option('signcolumn', 'yes')

		-- Enable completion triggered by <c-x><c-o>
		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
		-- unfortunate, but tagfunc isn't async, so:
		buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		buf_set_keymap('n', '<c-w><c-]>', '<cmd>split | lua vim.lsp.buf.definition()<CR>', opts)

		-- Jumping/usual vim mappings
		buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

		buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

		-- Workspaces
		--buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
		--buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
		--buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

		-- <space> prefixed ones, etc
		buf_set_keymap('n', '<space>t', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
		buf_set_keymap('n', '<space>c', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

		buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

		--buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format({ async = false })<CR>', opts)
		buf_set_keymap('n', '<space>gq', '<cmd>lua vim.lsp.buf.format({ async = false })<CR>', opts)
		-- defaults to visual selection
		-- can go via `gq` if 'formatexpr' is vim.lsp.formatexpr()
	end

	-- rustup component add rust-analyzer
	-- npm i -g [--prefix ~/src/npm/] pyright ts_ls
	local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
	if ok then
		local capabilities = cmp_nvim_lsp.default_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = false

		vim.lsp.config("*", {
			-- this lets LSP give us back a few more things, like some snippets
			capabilities = capabilities,
		})
	end

	vim.api.nvim_create_augroup("LspVimrc", {clear = true})
	vim.api.nvim_create_autocmd('LspAttach', {
		desc = "lsp setup callback",
		group = "LspVimrc",
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			on_attach(client, ev.buf)
		end
	})

	if vim.lsp.enable then
		local servers = { 'rust_analyzer', 'pyright', 'ts_ls' }
		for _, ls_name in ipairs(servers) do
			vim.lsp.enable(ls_name)
		end
	else
		vim.cmd.echom("'lsp setup: new vim.lsp API not present'")
	end
end

-- can't lazy load nvim-lspconfig, but we can delay this setup
-- ... or can we? lua vim.lsp.stop_client(vim.lsp.get_active_clients())

if vim.g.machine_fast then
	setup()
else
	vim.api.nvim_create_user_command(
		'LspVimrcSetup',
		setup,
		{
			bar = true,
		}
	)
end

--hi DiagnosticUnderlineError cterm=none
--hi DiagnosticUnderlineWarn cterm=none
--hi DiagnosticUnderlineInfo cterm=none
--hi DiagnosticUnderlineHint cterm=none
