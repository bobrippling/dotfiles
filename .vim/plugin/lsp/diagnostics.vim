nnoremap <silent> <Space>e <Cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> [d <Cmd>lua vim.diagnostic.jump({count=1, float=true})<CR>
nnoremap <silent> ]d <Cmd>lua vim.diagnostic.jump({count=1, float=true})<CR>
nnoremap <silent> <Space>q <Cmd>lua vim.diagnostic.setqflist()<CR>

" don't flicker the sign column when swapping normal/insert
try | set signcolumn=auto:1-9 | catch /^E474:/ | endtry


if has('lua')
	lua vim.diagnostic.config({ severity_sort = true })
endif
