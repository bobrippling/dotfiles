let g:trim_spaces = 1

function! s:trim_spaces()
	if g:trim_spaces == 0 || (exists('b:trim_spaces') && b:trim_spaces == 0)
		return
	endif

	let orig = getreg('Z')
	normal mZ
	%s/\s\+$//e
	if line("'Z") != line(".")
		echo "Stripped whitespace\n"
	endif
	normal 'Z
	call setreg('Z', orig)
endfunction

autocmd BufWritePre * call s:trim_spaces()
command! -complete=command -nargs=+ NoTrim
			\ let save = g:trim_spaces |
			\ let g:trim_spaces = 0 |
			\ <args> |
			\ let g:trim_spaces = save
