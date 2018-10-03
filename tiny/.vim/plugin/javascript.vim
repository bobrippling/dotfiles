let s:debug = 0

function! s:contains_only_iskeyword_chars(str)
    return match(a:str, "^\\k\\+$") == 0
endfunction

function! GotoJsTag()
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
    let import_search = "^import[^'\"]*\\<" . tag . "\\>"
    execute "keepjumps normal G?" . import_search . "$?['\"]hgf"

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

function! s:rewind_keyword(line, col)
    let col = a:col
    while col > 0 && s:contains_only_iskeyword_chars(strpart(a:line, col - 1, 1))
        let col -= 1
    endwhile
    return col
endfunction

function! s:find_before_dot(line, col)
    let col = s:rewind_keyword(a:line, a:col)

    if strpart(a:line, col - 1, 1) != "."
        return ""
    endif

    let end = col - 1
    let start = s:rewind_keyword(a:line, end - 1)

    return a:line[start : end - 1]
endfunction

function! s:find_after_dot(line, col)
    let col = a:col
    while s:contains_only_iskeyword_chars(strpart(a:line, col - 1, 1))
        let col += 1
    endwhile

    if strpart(a:line, col - 1, 1) != "."
        let bit = strpart(a:line, col - 1, 1)
        return ""
    endif

    let start = col + 1
    call cursor(line("."), start)
    return expand("<cword>")
endfunction

function! Jscomplete(findstart, base)
    let col = col(".")
    let line = getline(".")

    if a:findstart
        let col -= 1
        while col > 0 && s:contains_only_iskeyword_chars(line[col - 1])
            let col -= 1
        endwhile

        if s:debug
            let t = line[col : col(".")]
            echom "--- Jscomplete, start col:" col "text:" t
        endif
        return col
    endif

    let obj = s:find_before_dot(line, col - 1)
    if len(obj) == 0
        return []
    endif

    if s:debug
        execute 'echom "Jscomplete: before dot=' . obj . ' (base=' . a:base . ')"'
    endif

    let matches = []
    let save_cursor = getcurpos()
    call cursor(1, 0)
    while 1
        let s = "\\C\\<" . obj . "\\>\\."
        if search(s, "W") == 0
            break
        endif

        let matchpos = getcurpos()
        let col = matchpos[2]
        let member = s:find_after_dot(getline(matchpos[1]), col)

        if s:debug
            execute 'echom "Jscomplete match=' . member . ', at line ' . matchpos[1] . ', column ' . col . '"'
        endif

        if len(member) && (len(a:base) == 0 || member[0 : len(a:base) - 1] == a:base)
            call add(matches, member)
        endif
    endwhile
    call cursor(save_cursor[1:])

    return { 'words': matches, 'refresh': 'always' }
endfunction

augroup JavaScript
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <C-]> :<C-U>call GotoJsTag()<CR>
    autocmd FileType javascript nnoremap <buffer> <C-W><C-]> :sp<CR>:<C-U>call GotoJsTag()<CR>
    autocmd FileType javascript set suffixesadd+=.js,.jsx
    autocmd FileType javascript set omnifunc=Jscomplete
augroup END
