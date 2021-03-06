if !exists("g:autosave_enabled")
	let g:autosave_enabled = 0
endif

function! s:save(saved, ent) abort
	if !empty(&buftype) || !&modified
		return
	endif
	if exists('b:autosave') && b:autosave == 0
		return
	endif
	if empty(glob(expand("%")))
		return
	endif

	silent update
	call add(a:saved, a:ent)
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

	let saved = []
	for ent in modified
		let buf = ent.bufnr

		if bufnr("") is buf
			call s:save(saved, ent)
			continue
		endif

		let found = win_findbuf(buf)
		if !empty(found) && win_gotoid(found[0])
			call s:save(saved, ent)
			continue
		endif

		if empty(restore_wins)
			let restore_wins = winrestcmd()
		endif

		execute "sbuffer" buf
		call s:save(saved, ent)
		close!
	endfor

	call win_gotoid(focus)
	if !empty(restore_wins)
		execute restore_wins
	endif

	call map(saved, { _, ent -> fnamemodify(ent.name, ":~:.") })

	let skipped = len(modified) - len(saved)
	if len(saved)
		" truncate if too short
		let msg = "autosaved: " . join(saved, ", ")

		if skipped > 0
			let msg .= " (" . skipped . " skipped)"
		endif
	else
		let msg = "autosave, skipped " . skipped
	endif

	let now = "[" . strftime("%Y-%m-%d %H:%M:%S") . "] "
	let full = now . msg

	" -3, since vim seems to show the enter prompt even if we don't hit the end
	if len(full) < (&columns * &cmdheight) - 3
		echo full
	else
		echo now "[autosave...]"
	endif
endfunction

augroup autosave
	autocmd!

	autocmd CursorHold * ++nested call Autosave()
	"autocmd CursorHoldI * update|startinsert

	autocmd FocusLost * ++nested call Autosave()
augroup END
