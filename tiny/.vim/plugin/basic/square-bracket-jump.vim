function! s:to_pair(restore_visual, start, end, flags)
	if a:restore_visual
		normal! gv
	endif

	let skips = v:count
	function! s:decrement() closure
		let skips -= 1
		return skips > 0
	endfunction

	call searchpair(a:start, '', a:end, a:flags, function('s:decrement'))
endfunction

" need <C-U> on all for v:count clearing
nnoremap <silent> [% :<C-U>call <SID>to_pair(0, '\[', '\]', 'Wb')<CR>
nnoremap <silent> ]% :<C-U>call <SID>to_pair(0, '\[', '\]', 'W')<CR>
nnoremap <silent> [< :<C-U>call <SID>to_pair(0, '<', '>', 'Wb')<CR>
nnoremap <silent> ]> :<C-U>call <SID>to_pair(0, '<', '>', 'W')<CR>

vnoremap <silent> [% :<C-U>call <SID>to_pair(1, '\[', '\]', 'Wb')<CR>
vnoremap <silent> ]% :<C-U>call <SID>to_pair(1, '\[', '\]', 'W')<CR>
vnoremap <silent> [< :<C-U>call <SID>to_pair(1, '<', '>', 'Wb')<CR>
vnoremap <silent> ]> :<C-U>call <SID>to_pair(1, '<', '>', 'W')<CR>

" see also after/ftplugin/html.vim
