function! s:RestoreCursor()
	if line("'\"") > 1
	\ && line("'\"") <= line("$")
	\ && &ft !=# "gitcommit"
		exe "normal! g`\""
	endif
endfunction

autocmd BufReadPost * call s:RestoreCursor()
