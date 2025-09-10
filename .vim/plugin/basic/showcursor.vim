let s:count = 0
let s:orig_line = 0
let s:orig_col = 0

function! s:ShowCursor()
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
		let &l:cursorline = s:orig_line
		let &l:cursorcolumn = s:orig_col
	endif
endfunction

function! s:Enable(enable)
	augroup ShowCursor
		autocmd!

		if a:enable
			autocmd TabEnter,WinEnter * call s:ShowCursor()
		endif
	augroup END
endfunction

command! -bar ShowCursor call s:ShowCursor()
command! -bar ShowCursorEnable call s:Enable(1)
command! -bar ShowCursorDisable call s:Enable(0)
