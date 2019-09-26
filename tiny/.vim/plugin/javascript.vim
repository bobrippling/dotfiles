function! s:contains_only_iskeyword_chars(str)
    return match(a:str, "^\\k\\+$") == 0
endfunction

function! s:extended_tag_from_cursor()
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

    return [tag, ident]
endfunction

function! JsTagInCurFile(ident) abort
    keepjumps if searchdecl(a:ident, 1) == 0
        return
    endif

    " not found via searchdecl

    " - can't do ijump in a sandbox, emulate below instead
    "execute "ijump " . a:ident

    " c: accept match at cursor
    " W: no wrap around
    " z: start at cursor
    call search("\\C\\v<" . a:ident . ">", "cW")
endfunction

function! JsTag(pattern, flags, info) abort
    let based_on_normalmode_cursor = stridx(a:flags, "c") >= 0
    let for_completion =  stridx(a:flags, "i") >= 0

    if for_completion
        return []
    elseif based_on_normalmode_cursor
        let [tag, ident] = s:extended_tag_from_cursor()
    else
        " :tag, etc
        let tag = a:pattern
        let ident = a:pattern
    endif

    let import_search = "^import[^'\"]*\\<" . tag . "\\>\\C"
    let found_line = search(import_search, "wc") " w: wrap around, c: accept match at cursor
    if found_line == 0
        " not found
        return []
    endif

    " search forward to handle cases like import ... from 'abc'; // 'avoid matching here'
    let line = getline(found_line)
    let nextfile = substitute(line, "\\v\\C.*(['\"])(.*)\\1.*", "\\2", "")
    if nextfile == line
        " failed to extract filename
        return []
    endif

    let nextfile = findfile(nextfile)

    return [{
    \    "name": ident,
    \    "filename": nextfile,
    \    "cmd": tag == ident ? ":" : "call JsTagInCurFile('" . ident . "')",
    \ }]
endfunction

augroup JavaScript
    autocmd!
    autocmd FileType javascript set tagfunc=JsTag
    autocmd FileType javascript set suffixesadd+=.js,.jsx
    autocmd FileType javascript set omnifunc=Dotcomplete
augroup END
