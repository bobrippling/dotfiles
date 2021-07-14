inoremap <C-X>l <C-O>:call <sid>linemap()<CR><C-X><C-L>

function! s:linemap()
	let s:cpt_save = &complete
	set complete=.

	if has("patch1113")
		autocmd CompleteDone * ++once call s:linemap_finish()
	else
		" v8.1.1113 introduced `++once`
		augroup CompleteLinemap
			autocmd CompleteDone * call s:linemap_finish()
		augroup END
	endif
endfunction

function! s:linemap_finish()
	let &complete = s:cpt_save
	if !has("patch1113")
		augroup CompleteLinemap
			autocmd!
		augroup END
	endif
endfunction
