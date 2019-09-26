function! s:contains_only_iskeyword_chars(str)
    return match(a:str, "^\\k\\+$") == 0
endfunction

function! GotoJsTag(preview_window)
    if a:preview_window
        pedit +call\ GotoJsTag(0)
        return
    endif

    let savesearch = @/
    let cursor_list = getcurpos() " buffer,line,col,off,curswant
    let line = getline(".")
    let dot = strridx(line, '.', cursor_list[2]-1)

    if dot >= 0
        let dot_to_tag = strpart(line, dot+1, cursor_list[2] - (dot+1))
        if !s:contains_only_iskeyword_chars(dot_to_tag)
            " we're somewhere like "abc.xyz = hello"
            "                                   ^
            " and have found the dot before
            let dot = -1
        endif
    endif

    if dot >= 0
        let ident = expand("<cword>")

        call cursor(cursor_list[1], dot - 1)
        let tag = expand("<cword>")
    else
        let tag = expand("<cword>")
        let ident = tag
    endif

    " set jumplist just once, here, and don't affect it below
    mark `

    let curbuf = bufnr("%")
    let import_search = "^import[^'\"]*\\<" . tag . "\\>\\C"
    " search forward to handle cases like import ... from 'abc'; // 'avoid matching here'
    execute "keepjumps normal G?" . import_search . "/['\"]lgf"

    if bufnr("%") != curbuf
        " import 'gf' was successful, find ident
        if searchdecl(ident, 1) != 0
            " not found via searchdecl
            execute "silent! keepjumps ijump " . ident
        endif
    else
        keepjumps normal ''
    endif

    call histdel("/", -1)
    let @/ = savesearch
endfunction

augroup JavaScript
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <C-]> :<C-U>call GotoJsTag(0)<CR>
    autocmd FileType javascript nnoremap <buffer> <C-W><C-]> :sp<CR>:<C-U>call GotoJsTag(0)<CR>

    autocmd FileType javascript nnoremap <buffer> <C-W>} :<C-U>call GotoJsTag(1)<CR>

    autocmd FileType javascript set suffixesadd+=.js,.jsx
    autocmd FileType javascript set omnifunc=Dotcomplete
augroup END
