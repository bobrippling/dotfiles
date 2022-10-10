command! -bar -nargs=* RustMonitor call s:RustMonitor(<q-args>)

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

setlocal expandtab tabstop=4
