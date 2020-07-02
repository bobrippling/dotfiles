function! s:to_pair(restore_visual, start, end, flags)
	if a:restore_visual
		normal! gv
	endif

	let skips = v:count
	function! s:decrement() closure
		let skips -= 1
		return skips > 0 ? 1 : 0
	endfunction

	call searchpair(a:start, '', a:end, a:flags, function('s:decrement'))
endfunction

nnoremap <silent> [% :call s:to_pair(0, '\[', '\]', 'Wb')<CR>
nnoremap <silent> ]% :call s:to_pair(0, '\[', '\]', 'W')<CR>
nnoremap <silent> [< :call s:to_pair(0, '<', '>', 'Wb')<CR>
nnoremap <silent> ]> :call s:to_pair(0, '<', '>', 'W')<CR>

vnoremap <silent> [% :<C-U>call s:to_pair(1, '\[', '\]', 'Wb')<CR>
vnoremap <silent> ]% :<C-U>call s:to_pair(1, '\[', '\]', 'W')<CR>
vnoremap <silent> [< :<C-U>call s:to_pair(1, '<', '>', 'Wb')<CR>
vnoremap <silent> ]> :<C-U>call s:to_pair(1, '<', '>', 'W')<CR>
