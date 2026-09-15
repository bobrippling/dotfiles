function! s:replaste(l1, l2, reg)
	exe 'silent' a:l1 .. ',' .. a:l2 'd_'
	let empty = line('$') == 1 && empty(getline(0))
	exe 'pu!' (empty(a:reg) ? '*' : a:reg)
	if empty
		$d
	endif
endfunction

command! -bar -register -range=% Replaste call s:replaste(<line1>, <line2>, <q-reg>)
