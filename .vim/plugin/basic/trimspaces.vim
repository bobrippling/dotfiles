if !exists("g:trim_spaces")
	let g:trim_spaces = 1
endif
if !exists("g:trim_spaces_ignore")
	let g:trim_spaces_ignore = []
endif

function! TrimSpaces()
	if g:trim_spaces == 0 || get(b:, 'trim_spaces', 1) == 0 || get(w:, 'trim_spaces', 1) == 0
		return
	endif

	let full = expand("%:p")
	for path in g:trim_spaces_ignore
		if stridx(full, path) == 0
			if &verbose > 0
				echo "Not stripping spaces - ignore path matches\n"
				" newline above - ensure this message is seen/not overwritten
				" by the :w message
			endif
			return
		endif
	endfor

	let where = getcurpos()
	keeppatterns %s/\s\+$//e
	let jumped = getcurpos()

	let lnum = 1
	let col = 2
	let off = 3

	if where[lnum] != jumped[lnum] || where[col] != jumped[col]
		echo "Stripped whitespace\n"
	endif
	call cursor(where[lnum], where[col], where[off])
endfunction

augroup TrimSpaces
	autocmd!
	autocmd BufWritePre * call TrimSpaces()
	autocmd BufNewFile *.org let b:trim_spaces = 0
augroup END

command! -bar -complete=command -nargs=+ NoTrim
			\ let s:save = g:trim_spaces |
			\ let g:trim_spaces = 0 |
			\ <args> |
			\ let g:trim_spaces = s:save
