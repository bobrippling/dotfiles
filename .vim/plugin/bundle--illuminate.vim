if !exists('g:Illuminate_ftblacklist')
	let g:Illuminate_ftblacklist = ['', 'qf']
elseif index(g:Illuminate_ftblacklist, 'qf') == -1
	let g:Illuminate_ftblacklist += ['qf']
endif
