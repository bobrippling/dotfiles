nnoremap <silent> <Space>e <Cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> [d <Cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <Cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <Space>q <Cmd>lua vim.diagnostic.setqflist()<CR>

" don't flicker the sign column when swapping normal/insert
set signcolumn=auto:1-9

if has('lua')
	lua vim.diagnostic.config({ severity_sort = true })
endif
