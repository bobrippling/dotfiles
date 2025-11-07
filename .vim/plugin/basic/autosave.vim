let g:autosave_enabled = get(g:, "autosave_enabled", 0)

function! s:save(ent) abort
	" can't check {w,t}:autosave any other way (easily)
	if !get(w:, 'autosave', 1) || !get(t:, 'autosave', 1)
		return "disabled"
	endif
	if empty(glob(expand(a:ent.name)))
		" do this check here so we get a prompt about skipped files
		return "enoent"
	endif

	silent update
	if &modified
		" save failed, abort
		throw "save-fail:" . expand("%")
	endif
	return "saved"
endfunction

function! s:can_autosave(ent)
	if empty(a:ent.name)
		return 0
	endif

	if !getbufvar(a:ent.bufnr, "&modified")
		return 0
	endif

	if !empty(getbufvar(a:ent.bufnr, "&buftype"))
		return 0
	endif

	if getbufvar(a:ent.bufnr, "autosave", 1) == 0
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
	for ent in modified
		let ent.result = "<n/a>"
	endfor

	if empty(modified)
		return
	endif

	echo "autosaving..."
	redraw

	let focus = win_getid()
	let restore_wins = ''
	let error = ''

	augroup autosave_tmp
		autocmd!
		" return empty, i.e. do nothing, not even prompt the user
		autocmd FileChangedShell * let v:fcs_choice = ''
	augroup END

	let skipped = []
	try
		for ent in modified
			let buf = ent.bufnr

			if bufnr("") is buf
				let ent.result = s:save(ent)
				continue
			endif

			let found = win_findbuf(buf)
			if !empty(found) && win_gotoid(found[0])
				let ent.result = s:save(ent)
				continue
			endif

			if empty(restore_wins)
				let restore_wins = winrestcmd()
			endif

			execute "sbuffer" buf
			let ent.result = s:save(ent)
			close!
		endfor
	catch /^save-fail:.*/
		let buf = substitute(v:exception, '[^:]*:', '', '')
		let error = "Error saving " . buf
		augroup autosave_tmp
			autocmd!
		augroup END
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

	let nsaved = 0
	for ent in modified
		if ent.result ==# "saved"
			let nsaved += 1
		endif
	endfor

	let nskipped = len(modified) - nsaved
	if nsaved
		let saved_summary = map(
		\ filter(
		\   copy(modified),
		\   { _, ent -> ent.result ==# "saved" }),
		\   { _, ent -> fnamemodify(ent.name, ":~:.") }
		\ )
		let msg = "autosaved: " . join(saved_summary, ", ")

		if nskipped > 0
			let msg .= " (" . nskipped . " skipped)"
		endif
	else
		let msg = "autosave, skipped " . nskipped
	endif

	let now = s:now() . " "
	let full = now . msg

	if len(full) < v:echospace
		echo full
	else
		echo now . "[" . nsaved . " auto" . (nskipped ? " " . nskipped . " skip" : "") . "]"
	endif

	if &verbose && nskipped > 0
		for ent in modified
			if ent.result !=# "saved"
				echo ent.result . ":" fnamemodify(ent.name, ":~:.")
			endif
		endfor
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
