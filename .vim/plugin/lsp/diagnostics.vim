nnoremap <silent> <Space>e <Cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <Space>q <Cmd>lua vim.diagnostic.setqflist()<CR>

if !empty(mapcheck(']d', 'n'))
	augroup lspdiag
		au!
		autocmd LspAttach *
		\ nnoremap <buffer> <silent> [d <Cmd>lua vim.diagnostic.jump({count=-1, float=true})<CR>
		\ | nnoremap <buffer> <silent> ]d <Cmd>lua vim.diagnostic.jump({count=1, float=true})<CR>
	augroup END
endif

if has('lua')
	lua vim.diagnostic.config({ severity_sort = true })
endif
