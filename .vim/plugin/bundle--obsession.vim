if g:machine_fast | finish | endif

let s:persist_fn = ''

function! s:init(timer_id)
	let funcs = split(execute('filter /[0-9]_persist\>/ func'), "\n")
	if len(funcs) != 1
		echoerr "obsession++: couldn't find persist function (found" len(funcs) "functions)"
		return
	endif

	" function <SNR>00_persist() abort
	let f = substitute(funcs[0], '^function \(<SNR>\d\+_persist\)() abort$', '\1', '')
	if f ==# funcs[0]
		echoerr "obsession++: couldn't extract persist function (from \"" . funcs[0] . "\")"
		return
	endif

	let s:persist_fn = f

	augroup obsession_extra
		au!
		autocmd CursorHold * call s:obsession_ex_persist()
	augroup END
endfunction

function! s:obsession_ex_persist()
	execute "call" s:persist_fn . "()"
endfunction

let g:obsession_no_bufenter = 1

" wait for obsession to load
call timer_start(500, funcref('s:init'))
