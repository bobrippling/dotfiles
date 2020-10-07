let g:showcursor_enabled = 0

let s:count = 0
let s:orig_line = 0
let s:orig_col = 0

function! s:ShowCursor()
	if !g:showcursor_enabled
		return
	endif

	let s:count = 6

	let s:orig_line = &cursorline
	let s:orig_col = &cursorcolumn

	call s:Toggle(0)
endfunction

function! s:Toggle(timerid)
	set cursorline! cursorcolumn!

	let s:count -= 1
	if s:count > 0
		call timer_start(250, function('s:Toggle'))
	else
		let &cursorline = s:orig_line
		let &cursorcolumn = s:orig_col
	endif
endfunction

command ShowCursor call s:ShowCursor()

augroup ShowCursor
	autocmd!

	autocmd TabEnter,WinEnter * ShowCursor
augroup END
