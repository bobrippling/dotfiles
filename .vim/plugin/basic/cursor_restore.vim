function! s:jump_to_last()
	let m = line("'\"")

	if m <= 1 || m > line("$")
		return
	endif

	if &ft ==# "gitcommit"
		return
	endif

	let post = "zv"

	if &ft ==# "org"
		" avoid fold slowdown
		let post = ""
	endif

	exe "normal! g`\"" . post
endfunction

augroup CursorRestore
	autocmd!
	autocmd BufReadPost * call s:jump_to_last()
augroup END
