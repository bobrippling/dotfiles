cnoremap <expr> <C-K> <SID>clrtoeol_cmd()

function! s:clrtoeol_cmd() abort
    let cmd = getcmdline()
    let pos = getcmdpos() - 1

    let n = len(cmd) - pos

    return repeat("\<Del>", n)
endfunction
