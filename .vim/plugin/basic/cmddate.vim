function! s:get_date()
	return strftime("%Y-%m-%d-")
endfunction

cnoremap <expr> <C-R><C-D> <SID>get_date()
