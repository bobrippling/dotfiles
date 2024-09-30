cnoremap <expr> <C-K> <SID>clrtoeol_cmd()
cnoremap <expr> <C-R><C-B> <SID>curbuf()
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
