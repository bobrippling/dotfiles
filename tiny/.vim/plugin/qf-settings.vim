augroup QfSettings
	autocmd!

	autocmd FileType qf setlocal number
augroup END

function! s:toggle() abort
    let loclist_winid = get(getloclist(0, { 'winid': 0 }), 'winid', 0)
    if loclist_winid != 0
        lclose
        return
    endif

    let qflist_winid = get(getqflist({ 'winid': 0 }), 'winid', 0)
    if qflist_winid != 0
        cclose
        return
    endif

    rightbelow copen
endfunction

nnoremap <silent> <leader>c :call <SID>toggle()<CR>
