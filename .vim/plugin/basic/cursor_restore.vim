function! s:jump_to_last()
	if line("'\"") > 1
	\ && line("'\"") <= line("$")
	\ && index(["gitcommit", "org"], &ft) == -1
		exe "normal! g`\"zv"
	endif
endfunction

augroup CursorRestore
	autocmd!
	autocmd BufReadPost * call s:jump_to_last()
augroup END
