if exists(":packadd")
	packadd matchit
endif

" ------------

function! s:tagjump(count, forward, visual)
	if a:visual
		normal! gv
	endif

	let start = '<[a-zA-Z][a-zA-Z0-9]*\%( .*\)\?>'
	let end = '</[a-zA-Z][a-zA-Z0-9]*>'

	" a:count is needed for visual ones
	let skips = a:count
	function! s:decrement() closure
		let skips -= 1
		return skips > 0
	endfunction

	mark '
	let flags = 'W' . (a:forward ? '' : 'b')
	call searchpair(start, '', end, flags, function('s:decrement'))
endfunction

" need <C-U> on all to not interfere with counted jumps / :.,+2call [...]
nnoremap <buffer> <silent> [t :<C-U>call <SID>tagjump(v:count, 0, 0)<CR>
nnoremap <buffer> <silent> ]t :<C-U>call <SID>tagjump(v:count, 1, 0)<CR>
vnoremap <buffer> <silent> [t :<C-U>call <SID>tagjump(v:count, 0, 1)<CR>
vnoremap <buffer> <silent> ]t :<C-U>call <SID>tagjump(v:count, 1, 1)<CR>

" see also plugin/basic/square-bracket-jump.vim
