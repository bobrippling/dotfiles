function! Joinoperator(submode)
	let save = @j
	normal! $mj
	'[,']join
	normal! `jl
	let @j = save
endfunction

function! JoinoperatorNoSpace(submode)
	let save = @j
	normal! $mj
	'[,']join!
	normal! `jl
	let @j = save
endfunction

nnoremap <silent> J :set operatorfunc=Joinoperator<CR>g@
nnoremap <silent> gJ :set operatorfunc=JoinoperatorNoSpace<CR>g@

set nojoinspaces
