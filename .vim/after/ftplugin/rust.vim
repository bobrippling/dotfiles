let s:buf_test = 0
let s:buf_run = 0

function! s:RustMonitor(args) abort
	let focus = win_getid()

	if empty(a:args) && (s:buf_run || s:buf_test)
		call s:disable()
	else
		call s:disable()
		call s:enable(a:args)
	endif

	call win_gotoid(focus)
endfunction

function! s:enable(args) abort
	botright vnew
	let s:buf_test = bufnr("")
	execute "terminal find src/ -iname '*.rs' | entr -cr cargo test" a:args

	rightbelow new
	let s:buf_run = bufnr("")
	execute "terminal find src/ -iname '*.rs' | entr -cr cargo run" a:args
endfunction

function! s:disable() abort
	if s:buf_test
		call s:terminate(s:buf_test)
		let s:buf_test = 0
	endif
	if s:buf_run
		call s:terminate(s:buf_run)
		let s:buf_run = 0
	endif
endfunction

function! s:terminate(buf) abort
	let w = bufwinnr(a:buf)
	if w == -1
		return
	endif

	let w = win_getid(w)
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

command! -buffer -bar -nargs=* RustMonitor call s:RustMonitor(<q-args>)
