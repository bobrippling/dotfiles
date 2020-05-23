if has("nvim")
	finish
endif

function! s:esc_term() abort
	if &buftype ==# "terminal"
		call feedkeys("\<C-\>\<C-N>", "nx")
	endif
endfunction

augroup TermLeave
	autocmd!

	autocmd WinEnter,BufWinEnter * call s:esc_term()
augroup END
