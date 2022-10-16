function! s:jump_to_last()
	if line("'\"") > 1
	\ && line("'\"") <= line("$")
	\ && &ft !=# "gitcommit"
		exe "normal! g`\""
	endif
endfunction

autocmd BufReadPost * call s:jump_to_last()
