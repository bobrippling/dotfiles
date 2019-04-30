let g:trim_spaces = 1

function! s:trim_spaces()
	if g:trim_spaces == 0 || (exists('b:trim_spaces') && b:trim_spaces == 0)
		return
	endif

	let where = getcurpos()
	%s/\s\+$//e
	let jumped = getcurpos()

	let lnum = 1
	let col = 2
	let off = 3

	if where[lnum] != jumped[lnum] || where[col] != jumped[col]
		echo "Stripped whitespace\n"
	endif
	call cursor(where[lnum], where[col], where[off])
endfunction

autocmd BufWritePre * call s:trim_spaces()
command! -complete=command -nargs=+ NoTrim
			\ let save = g:trim_spaces |
			\ let g:trim_spaces = 0 |
			\ <args> |
			\ let g:trim_spaces = save
