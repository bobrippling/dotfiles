nnoremap <Space>e <Cmd>lua vim.diagnostic.open_float()<CR>

if has('lua')
	lua vim.diagnostic.config({ severity_sort = true })
endif
