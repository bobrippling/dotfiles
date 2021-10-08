augroup QfSettings
	autocmd!

	autocmd FileType qf setlocal number
augroup END

function! s:toggle() abort
	if qf#loc_list_open()
		lclose
		return
	endif

	if qf#qf_list_open()
		cclose
		return
	endif

	rightbelow copen
endfunction

nnoremap <silent> <leader>c :call <SID>toggle()<CR>

function s:nav(backwards, file) abort
	let loclist_winid = get(getloclist(0, { 'winid': 0 }), 'winid', 0)
	let have_open_loclist = loclist_winid != 0

	let cmd =  ":" . v:count1 . (have_open_loclist ? "l" : "c") . (a:backwards ? "p" : "n") . (a:file ? "f" : "") . "\n"
	return cmd
endfunction

nnoremap <expr> <silent> ]q <SID>nav(0, 0)
nnoremap <expr> <silent> ]Q <SID>nav(0, 1)
nnoremap <expr> <silent> [q <SID>nav(1, 0)
nnoremap <expr> <silent> [Q <SID>nav(1, 1)
