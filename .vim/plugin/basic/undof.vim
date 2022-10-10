function! s:rm_undo()
	let file = undofile(expand("%"))
	if empty(file)
		echo "no undo file"
		return
	endif

	let r = delete(file)
	if r != 0
		echo "couldn't delete" file
	endif
endfunction

command! -bar RmUndo call s:rm_undo()
