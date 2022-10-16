function! s:jump_to_last()
	if line("'\"") > 1
	\ && line("'\"") <= line("$")
	\ && &ft !=# "gitcommit"
		exe "normal! g`\""
	endif
endfunction

augroup CursorRestore
	autocmd!
	autocmd BufReadPost * call s:jump_to_last()
augroup END
