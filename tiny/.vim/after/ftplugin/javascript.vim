function s:debug(s) abort
    if 0
        echom "jstag: " . a:s
    endif
endfunction

function! s:contains_only_iskeyword_chars(str) abort
    return match(a:str, "^\\k\\+$") == 0
endfunction

function! s:extended_tag_from_cursor() abort
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

        call cursor(cursor_list[1], dot) "dot: 0-based to 1-based
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

    call cursor(1, 1)
    " c: accept match at cursor
    " W: no wrap around
    " z: start at cursor column
    if search("\\C\\v<" . a:ident . ">", "cw") == 0
      echohl ErrorMsg
      echo "Couldn't find " . a:ident
      echohl None
    endif
endfunction

function! s:try_js_index(nextfile) abort
    let nextfile = a:nextfile
    let found = finddir(nextfile)
    if !empty(found)
        call s:debug("found dir " . found . ", trying index...")
        let index = findfile(found . '/index')
        if !empty(index)
            call s:debug("index found")
            let nextfile = index
        else
            call s:debug("index not found")
        endif
    endif
    return nextfile
endfunction

function! s:file_from_import(nextfile) abort
    " this function needs to do the equivalent of 'gf', which isn't the same as findfile()
    let nextfile = a:nextfile

    " findfile() doens't work on paths like "./abc" - remove prefix
    let nextfile = substitute(nextfile, "^\\./", "", "")

    " findfile() doesn't work on paths like "../abc" - remove prefix and expand path
    let updirs = 0
    while match(nextfile, "^\\.\\./") >= 0
        let nextfile = substitute(nextfile, "^\\.\\./", "", "")
        let updirs += 1
    endwhile
    let pathexpand = ""
    if updirs > 0
        let updirs += 1 " if we're doing a relative fix, chop off the filename first
        call s:debug("updirs: " . updirs)
        while updirs > 0
            let pathexpand .= ":h"
            let updirs -= 1
        endwhile
    endif

    " put current file's directory first, for priority
    let path = expand("%" . pathexpand) . "," . &path
    call s:debug("main findfile('" . nextfile . "', path) with path = '%" . pathexpand . "' ('" . path . "')")
    let found = findfile(nextfile, path)
    if empty(found)
        call s:debug("nothing found, trying js-index...")
        let nextfile = s:try_js_index(nextfile)
    else
        call s:debug("found '" . found . "'")
        let nextfile = found
    endif

    return nextfile
endfunction

function! s:scoped_tag_search(ident) abort
    " b: backwards, n: no cursor move, W: nowrapscan
    " r: keep going to the outer most (this is probably easier than trying to look for a function body
    let start_line = searchpair("{", "", "}", 'bnWr')
    if start_line <= 0
        call s:debug("couldn't find block start for " . tag . "." . ident)
        return []
    endif

    let end_line = searchpair("{", "", "}", 'nWr')
    if end_line <= 0
        call s:debug("couldn't find block end for " . tag . "." . ident)
        return []
    endif

    call cursor(start_line, 0)
    " c: cursor pos accept, n: no move cursor, W: no wrap
    let found = search("^\\C\\v\\s*((async|\*) *)*<" . a:ident . ">", "cnW", end_line)
    if found == 0
        call s:debug("couldn't find " . a:ident . " in " . start_line . "," . end_line)
        return []
    endif

    call s:debug("found local ident between " . start_line . "," . end_line . " on line " . found)

    return [{
    \    "name": a:ident,
    \    "filename": expand("%"),
    \    "cmd": string(found),
    \ }]
endfunction

function! JsTag(pattern, flags, info) abort
    let based_on_normalmode_cursor = stridx(a:flags, "c") >= 0
    let for_completion =  stridx(a:flags, "i") >= 0

    if for_completion
        return JsFileTags(based_on_normalmode_cursor ? a:pattern : "")
    elseif based_on_normalmode_cursor
        let [tag, ident] = s:extended_tag_from_cursor()

        if tag !=# ident && tag ==# "this"
            return s:scoped_tag_search(ident)
        endif
    else
        " :tag, etc
        let tag = a:pattern
        let ident = a:pattern
    endif

    let import_search = "^import[^'\"]*\\<" . tag . "\\>\\C"
    let found_line = search(import_search, "wc") " w: wrap around, c: accept match at cursor
    if found_line == 0
        " not found
        call s:debug("import line not found")
        return []
    endif

    " search forward to handle cases like import ... from 'abc'; // 'avoid matching here'
    let line = getline(found_line)
    let nextfile = substitute(line, "\\v\\C.*(['\"])(.*)\\1.*", "\\2", "")
    if nextfile == line
        " failed to extract filename
        call s:debug("couldn't extract filename from import line")
        return []
    endif

    let nextfile = s:file_from_import(nextfile)

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

set tagfunc=JsTag
let b:undo_ftplugin .= '|setlocal tagfunc<'

set suffixesadd+=.js,.jsx
let b:undo_ftplugin .= '|setlocal suffixesadd-=.js,.jsx'

set omnifunc=Dotcomplete
let b:undo_ftplugin .= '|setlocal omnifunc<'
