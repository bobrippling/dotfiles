augroup QfSettings
	autocmd!

	autocmd FileType qf setlocal number nowrap
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

	if a:file
		let cmd = (a:backwards ? "p" : "n") . "file"
	else
		" have to use 'next'/'previous' to avoid `:ln`, i.e. `:lnoremap`
		let cmd = (a:backwards ? "previous" : "next")
	endif

	let cmd =  ":\<C-U>" . v:count1 . (have_open_loclist ? "l" : "c") . cmd . "\n"

	return cmd
endfunction

nnoremap <expr> <silent> ]q <SID>nav(0, 0)
nnoremap <expr> <silent> ]Q <SID>nav(0, 1)
nnoremap <expr> <silent> [q <SID>nav(1, 0)
nnoremap <expr> <silent> [Q <SID>nav(1, 1)
