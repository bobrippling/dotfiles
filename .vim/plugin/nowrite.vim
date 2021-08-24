function! s:lighten_fs()
	if cwdprops#in_network_mount()
		set nowritebackup noswapfile
	endif
endfunction

augroup NoWrite
	autocmd!
	autocmd BufNewFile,BufFilePost * call s:lighten_fs()
augroup END
