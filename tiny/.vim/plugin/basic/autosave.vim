if !exists("g:autosave_enabled")
	let g:autosave_enabled = 0
endif

function! s:save() abort
	silent update
endfunction

function! Autosave() abort
	if !g:autosave_enabled || !empty(getcmdwintype())
		return
	endif

	let modified = getbufinfo({ "bufmodified": 1 })
	call filter(modified, { _, ent -> !empty(ent.name) && getbufvar(ent.bufnr, "&buftype") !=? "terminal"})

	if empty(modified)
		return
	endif

	let focus = win_getid()
	let restore_wins = ''

	for ent in modified
		let buf = ent.bufnr

		if bufnr() is buf
			call s:save()
			continue
		endif

		let found = win_findbuf(buf)
		if !empty(found) && win_gotoid(found[0])
			call s:save()
			continue
		endif

		if empty(restore_wins)
			let restore_wins = winrestcmd()
		endif

		execute "sbuffer" buf
		call s:save()
		close!
	endfor

	call win_gotoid(focus)
	if !empty(restore_wins)
		execute restore_wins
	endif

	call map(modified, { _, ent -> fnamemodify(ent.name, ":~:.") })
	echo "[" . strftime("%Y-%m-%d %H:%M:%S") . "] autosaved:" join(modified, ", ")
endfunction

augroup autosave
	autocmd!

	autocmd CursorHold * call Autosave()
	"autocmd CursorHoldI * update|startinsert

	autocmd FocusLost * call Autosave()
augroup END
