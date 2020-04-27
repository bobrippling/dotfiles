function! s:detect_lastused()
    let bi = getbufinfo()
    for b in bi
        if has_key(b, 'lastused')
            return 1
        endif
    endfor
    return 0
endfunction

let s:has_lastused = s:detect_lastused()

if !s:has_lastused
    augroup ChangedTime
        autocmd!
        autocmd BufAdd,BufNewFile,BufNew,BufLeave * let b:changedtime = localtime()
    augroup END
endif

function! s:when(buf)
    if s:has_lastused
        return getbufinfo(a:buf)[0].lastused
    else
        try
            return getbufvar(a:buf, 'changedtime')
        catch
            return "?"
        endtry
    endif
endfunction

function! s:buftimecmp(a, b)
    let a_time = s:when(a:a)
    let b_time = s:when(a:b)
    return a_time - b_time
endfunction

function! s:is_terminal(buf)
    return getbufvar(a:buf, "&buftype") == "terminal"
endfunction

function! s:buffers()
    let buffers = []

    for i in range(1, bufnr('$'))
        if !buflisted(i)
            continue
        endif
        if s:is_terminal(i)
            continue
        endif
        call add(buffers, i)
    endfor

    return buffers
endfunction

function! s:recentbuffers()
    return sort(s:buffers(), 's:buftimecmp')
endfunction

function! Lst()
    for i in s:recentbuffers()
        let when = s:when(i)
        if strlen(when)
            let when = " (" . strftime("%c", when) . ")"
        endif
        echon "[" . i . "]\t"
        if bufloaded(i)
            echohl Pmenu
        endif
        echon bufname(i)
        echohl NONE
        echon when . "\n"
    endfor
endfunction

function! TrimOldBuffers(count, bang)
    " bang = true: keep `count` many buffers
    " bang = false: remove `count` many buffers
    let recents = filter(s:recentbuffers(), { idx, buf -> !bufloaded(buf) })

    if len(a:bang)
        let remaining = min([len(recents) - 1, a:count])
        let delete = recents[:-remaining]
    else
        let count_to_trim = min([len(recents) - 1, a:count])
        let delete = recents[:count_to_trim - 1]
    endif

    for i in delete
        execute "bdelete " . i
    endfor
    echo "Deleted " . len(delete) . " buffers"
endfunction

function! s:fileexists(path)
    return !empty(glob(a:path, v:true))
endfunction

function! TrimUnlinkedBuffers()
    let delete = []
    for buf in s:buffers()
        let name = bufname(buf)
        if empty(name)
            continue
        endif
        if s:fileexists(name)
            continue
        endif

        call add(delete, buf)
    endfor

    execute "bdelete " . join(delete)
endfunction

command! Ls call Lst()
command! -bang -count=10 TrimOldBuffers call TrimOldBuffers(<count>, '<bang>')
command! TrimUnlinkedBuffers call TrimUnlinkedBuffers()
