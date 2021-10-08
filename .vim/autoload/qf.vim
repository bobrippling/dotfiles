function! qf#loc_list_open()
	let loclist_winid = get(getloclist(0, { 'winid': 0 }), 'winid', 0)
	return loclist_winid != 0
endfunction

function! qf#qf_list_open()
	let qflist_winid = get(getqflist({ 'winid': 0 }), 'winid', 0)
	return qflist_winid != 0
endfunction
