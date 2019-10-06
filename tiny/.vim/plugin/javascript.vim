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
        return JsFileTags(based_on_normalmode_cursor ? a:pattern : "")
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

    let nextfile = substitute(nextfile, "^\\./", "", "") " findfile() doens't work on paths like "./abc"
    let found = findfile(nextfile)
    if empty(found)
        let found = finddir(nextfile)
        if !empty(found)
            let index = findfile(found . '/index')
            if !empty(index)
                let nextfile = index
            endif
        endif
    else
        let nextfile = found
    endif

    return [{
    \    "name": ident,
    \    "filename": nextfile,
    \    "cmd": "call JsTagInCurFile('" . ident . "')",
    \ }]
endfunction

function! JsFileTags(pattern) abort
    let import_search = "\\v\\C^import[^'\"]+"
    let [buf; save_cursor] = getcurpos()

    let allents = []
    let flags = "cWz"
    let lnum = 0
    while 1
        call cursor(lnum + 1, 0)
        let lnum = search(import_search, flags)
        if lnum <= 0
            break
        endif

        let line = getline(lnum)
        let filename = substitute(line, "\\v\\C.*from (['\"])([^'\"]+)\\1.*", "\\2", "")
        let ent_str = substitute(line, "\\v\\C^import (.*) from.*", "\\1", "")
        let ents = filter(split(ent_str, "\\s*[{},]\\s*", 0), "!empty(v:val)")

        for ent in ents
            let ent = substitute(ent, "\\C\\v.* as (.*)", "\\1", "")

            if match(ent, a:pattern) < 0
                continue
            endif

            let allents += [{
            \    "name": ent,
            \    "filename": filename,
            \    "cmd": "call JsTagInCurFile('" . ent . "')",
            \ }]
        endfor
    endwhile

    call cursor(save_cursor)

    return allents
endfunction

augroup JavaScript
    autocmd!
    autocmd FileType javascript set tagfunc=JsTag
    autocmd FileType javascript set suffixesadd+=.js,.jsx
    autocmd FileType javascript set omnifunc=Dotcomplete
augroup END
