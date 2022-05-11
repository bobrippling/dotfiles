" from justinmk's vimrc
function! s:get(use_curbuf, cmd) abort
  redir => l:message
  silent! execute a:cmd
  redir END
  if !a:use_curbuf
		wincmd n
		set buftype=nofile
	endif
  silent put=l:message
	'[d_
endf

command! -nargs=+ -bang -complete=command R call s:get(<bang>0, <q-args>)
