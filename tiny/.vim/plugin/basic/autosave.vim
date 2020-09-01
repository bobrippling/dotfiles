let g:autosave_enabled = 0

function! s:autosave()
	if !g:autosave_enabled
		return
	endif

	if empty(expand("%"))
		return
	endif

	update
endfunction

augroup autosave
	autocmd!

	autocmd CursorHold * call <SID>autosave()
	"autocmd CursorHoldI * update|startinsert

	autocmd FocusLost * call <SID>autosave()
augroup END
