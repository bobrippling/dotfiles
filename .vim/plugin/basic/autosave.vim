let g:autosave_enabled = get(g:, "autosave_enabled", 0)
let g:autosave_verbose = get(g:, "autosave_verbose", 0)

function! s:save(ent, saved) abort
	if !empty(&buftype) || !&modified
		if g:autosave_verbose
			echom "autosave, skipping buf=" . a:ent.bufnr . ", bt=" . &bt . ", mod=" . &mod
		endif
		return
	endif
	if !get(b:, 'autosave', 1) || !get(w:, 'autosave', 1) || !get(t:, 'autosave', 1)
		return
	endif
	if empty(glob(expand("%")))
		return
	endif

	silent update
	if &modified
		" save failed, abort
		throw "save-fail:" . expand("%")
	endif
	call add(a:saved, a:ent)
endfunction

function! s:can_autosave(ent)
	if empty(a:ent.name) || getbufvar(a:ent.bufnr, "&buftype") ==? "terminal"
		return 0
	endif

	let enabled = getbufvar(a:ent.bufnr, "autosave", 1)
	if enabled == 0
		return 0
	endif

	let lines = getbufline(a:ent.bufnr, 1, "$")
	for line in lines
		if line =~# '^[<=>]\{7,}'
			" conflict in progress
			return 0
		endif
	endfor

	return 1
endfunction

function! Autosave() abort
	if !g:autosave_enabled || !empty(getcmdwintype())
		return
	endif

	let modified = getbufinfo({ "bufmodified": 1 })
	call filter(modified, { _, ent -> s:can_autosave(ent) })

	if empty(modified)
		return
	endif

	echo "autosaving..."
	redraw

	let focus = win_getid()
	let restore_wins = ''
	let error = ''

	let saved = []
	let skipped = []
	try
		for ent in modified
			let buf = ent.bufnr

			if bufnr("") is buf
				call s:save(ent, saved)
				continue
			endif

			let found = win_findbuf(buf)
			if !empty(found) && win_gotoid(found[0])
				call s:save(ent, saved)
				continue
			endif

			if empty(restore_wins)
				let restore_wins = winrestcmd()
			endif

			execute "sbuffer" buf
			call s:save(ent, saved)
			close!
		endfor
	catch /^save-fail:.*/
		let buf = substitute(v:exception, '[^:]*:', '', '')
		let error = "Error saving " . buf
		" cleanup below
	endtry

	call win_gotoid(focus)
	if !empty(restore_wins)
		execute restore_wins
	endif

	if !empty(error)
		echoerr error
		return
	endif

	call map(saved, { _, ent -> fnamemodify(ent.name, ":~:.") })

	let nskipped = len(modified) - len(saved)
	if len(saved)
		" truncate if too short
		let msg = "autosaved: " . join(saved, ", ")

		if nskipped > 0
			let msg .= " (" . nskipped . " skipped)"
		endif
	else
		let msg = "autosave, skipped " . nskipped
	endif

	let now = s:now() . " "
	let full = now . msg

	" -3, since vim seems to show the enter prompt even if we don't hit the end
	if len(full) < (&columns * &cmdheight) - 3
		echo full
	else
		echo now . "[" . len(saved) . " auto" . (nskipped ? " " . nskipped . " skip" : "") . "]"
	endif
endfunction

function! s:now()
	return "[" . strftime("%Y-%m-%d %H:%M:%S") . "]"
endfunction

augroup autosave
	autocmd!

	autocmd CursorHold * call Autosave()
	"autocmd CursorHoldI * update|startinsert

	autocmd FocusLost * call Autosave()
augroup END
