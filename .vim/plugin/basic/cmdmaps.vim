cnoremap <expr> <C-K> <SID>clrtoeol_cmd()
cnoremap <expr> <C-R><C-B> <SID>curbuf()
cnoremap <expr> <C-R>? <SID>search_term_no_boundaries()
cnoreabbrev '<,'> *

function! s:clrtoeol_cmd() abort
    let cmd = getcmdline()
    let pos = getcmdpos() - 1

    let n = len(cmd) - pos

    return repeat("\<Del>", n)
endfunction

function! s:curbuf() abort
	return bufnr("")
endfunction

function! s:search_term_no_boundaries()
	return substitute(@/, '\(^\\<\|\\>$\)', '', 'g')
endfunction
