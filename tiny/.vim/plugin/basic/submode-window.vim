function s:enable_mappings() abort
	call submode#enter_with('window', 'n', '', '<C-w>m')
	call submode#leave_with('window', 'n', '', '<ESC>')
	for key in ['a','b','c','d','e','f','g','h','i','j','k','l','m',
	\           'n','o','p','q','r','s','t','u','v','w','x','y','z']
		call submode#map('window', 'n', '', key, '<C-w>' . key)
		call submode#map('window', 'n', '', toupper(key), '<C-w>' . toupper(key))
		call submode#map('window', 'n', '', '<C-' . key . '>', '<C-w>' . '<C-'.key . '>')
	endfor
	for key in ['=','_','+','-','<','>']
		call submode#map('window', 'n', '', key, '<C-w>' . key)
	endfor
	let g:submode_timeout = 0
endfunction

function SubmodeWindowInit()
	nunmap <C-W>m
	call s:enable_mappings()
endfunction

nmap <C-W>m :call SubmodeWindowInit()<CR><C-W>m
