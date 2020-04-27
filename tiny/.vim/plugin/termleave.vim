if has("nvim")
	finish
endif

function! s:esc_term() abort
	if &buftype ==# "terminal"
		call feedkeys("\<C-\>\<C-N>", "n")
	endif
endfunction

augroup TermLeave
	autocmd!

	autocmd WinLeave * call s:esc_term()
augroup END
