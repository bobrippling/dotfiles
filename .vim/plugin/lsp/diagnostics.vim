nnoremap <silent> <Space>e <Cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> [d <Cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <Cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <Space>q <Cmd>lua vim.diagnostic.setqflist()<CR>

if has('lua')
	lua vim.diagnostic.config({ severity_sort = true })
endif
