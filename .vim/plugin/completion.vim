inoremap <C-X>l <C-O>:call <sid>linemap()<CR><C-X><C-L>

function! s:linemap()
	let s:cpt_save = &complete
	set complete=.

	autocmd CompleteDone * ++once call s:linemap_finish()
endfunction

function! s:linemap_finish()
	let &complete = s:cpt_save
endfunction
