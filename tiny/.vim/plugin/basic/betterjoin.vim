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

nnoremap J :silent set operatorfunc=Joinoperator<CR>g@
nnoremap gJ :silent set operatorfunc=JoinoperatorNoSpace<CR>g@

set nojoinspaces
