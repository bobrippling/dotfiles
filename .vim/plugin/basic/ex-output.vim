function! s:get(use_curbuf, cmd) abort
	let l:message = ''
	redir => l:message
	silent! execute a:cmd
	redir END
	if !a:use_curbuf
		wincmd n
		set buftype=nofile
	endif
	silent put=l:message
	1d_
endf

command! -bar -nargs=+ -bang -complete=command R call s:get(<bang>0, <q-args>)
