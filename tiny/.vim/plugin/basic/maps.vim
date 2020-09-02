function s:LeaderNext(presave) abort
	let curwin = win_getid()

	let have_open_loclist = 0
	for w in range(1, winnr('$'))
		let locs = getloclist(w, {'filewinid':0})
		if locs.filewinid == curwin
			let have_open_loclist = 1
			break
		endif
	endfor

	let cmd =  ":" . v:count1 . (have_open_loclist ? "lnext" : "cnext") . "\n"
	if a:presave
		let cmd = ":update | " . cmd
	endif
	return cmd
endfunction

nnoremap <expr> <silent> <leader>n <SID>LeaderNext(0)
nnoremap <expr> <silent> <leader>N <SID>LeaderNext(1)
