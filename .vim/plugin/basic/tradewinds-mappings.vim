if empty(filter(split(&rtp, ','), 'stridx(v:val, "vim-submode") >= 0'))
	finish
endif

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
