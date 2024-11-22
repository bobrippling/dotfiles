function! s:RustMonitor(args) abort
	let focus = win_getid()

	let was_running = s:disable()
	if !empty(a:args) || !was_running
		call s:enable(a:args)
	endif

	call win_gotoid(focus)
endfunction

function! s:enable(args) abort
	botright vnew
	execute "terminal find src/ -iname '*.rs' | entr -cr cargo test" a:args
	let b:rustm = "test"

	rightbelow new
	execute "terminal find src/ -iname '*.rs' | entr -cr cargo run" a:args
	let b:rustm = "run"
endfunction

function! s:disable() abort
	let r = 0

	for w in range(winnr("$"), 1, -1)
		let b = winbufnr(w)

		if !empty(getbufvar(b, "rustm"))
			call s:terminate(w)
			let r = 1
		endif
	endfor

	return r
endfunction

function! s:terminate(win) abort
	let w = win_getid(a:win)
	if !w || !win_gotoid(w)
		return
	endif

	" n: no remap, x: flush typeahead
	call feedkeys("i\<C-C>", "nx")
	q!
endfunction

function RustIncludeExpr(fname)
	let fname = a:fname

	if fname[:6] ==# 'crate::'
		let crate_root = substitute(expand('%:h') . '/', 'src/\zs.*', '', '')

		" replace crate:: with the root of the crate
		let fname = substitute(fname, 'crate::', crate_root, '')
	endif

	let fname = substitute(fname, '::', '/', 'g')

	" use a::b::{...}
	let fname = substitute(fname, '[:/]\+$', '', '')

	if !empty(findfile(fname))
		return fname
	endif

	let candidate = fnamemodify(fname, ':h')
	if !empty(findfile(candidate))
		return candidate
	endif

	let candidate = candidate . '/mod.rs'
	if !empty(findfile(candidate))
		return candidate
	endif

	return fname
endfunction

setlocal include=^use\\>\\s\\+
setlocal isfname+=:
setlocal includeexpr=RustIncludeExpr(v:fname)

setlocal expandtab tabstop=4
setlocal cinoptions+=#1

command! -buffer -bar -nargs=* RustMonitor call s:RustMonitor(<q-args>)
