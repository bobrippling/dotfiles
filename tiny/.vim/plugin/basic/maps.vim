function s:LeaderNext(presave) abort
	let loclist_winid = get(getloclist(0, { 'winid': 0 }), 'winid', 0)
	let have_open_loclist = loclist_winid != 0

	let cmd =  ":" . v:count1 . (have_open_loclist ? "lnext" : "cnext") . "\n"
	if a:presave
		let cmd = ":update | " . cmd
	endif
	return cmd
endfunction

nnoremap <expr> <silent> <leader>n <SID>LeaderNext(0)
nnoremap <expr> <silent> <leader>N <SID>LeaderNext(1)
