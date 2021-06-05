function! Joinoperator(submode)
	normal $mj
	'[,']join
	normal 'jl
endfunction

function! JoinoperatorNoSpace(submode)
	normal $mj
	'[,']join!
	normal 'jl
endfunction

nnoremap <silent> J :set operatorfunc=Joinoperator<CR>g@
nnoremap <silent> gJ :set operatorfunc=JoinoperatorNoSpace<CR>g@

set nojoinspaces
