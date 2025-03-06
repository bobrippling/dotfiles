" [ funcref ]
let g:ctrlb_handlers = get(g:, 'ctrlb_handlers', [])

function! s:handle_ctrlb()
	let cmdline = getcmdline()
	let cursor = getcmdpos()

	" isolate the current command
	let curcmd = substitute(cmdline, '.*|\([^|]\+\)$', '\1', '')
	let off = len(cmdline) - len(curcmd)

	for Ent in g:ctrlb_handlers
		let r = Ent(curcmd, off)
		if r isnot 0
			return r
		endif
	endfor

	echohl ErrorMsg
	echo "ctrlb: no matches"
	echohl none
	sleep 500m

	return "\<C-L>"
endfunction

cnoremap <expr> <C-B> <SID>handle_ctrlb()
