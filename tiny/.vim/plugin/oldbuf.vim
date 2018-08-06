if exists("loaded_oldbuf")
    finish
endif
let loaded_oldbuf = 1

augroup ChangedTime
  autocmd!
  autocmd BufAdd,BufNewFile,BufNew,BufLeave * let b:changedtime = localtime()
augroup END

function s:when(buf)
    try
        return getbufvar(a:buf, 'changedtime')
    catch
        return "?"
    endtry
endfunction

function s:buftimecmp(a, b)
    let a_time = s:when(a:a)
    let b_time = s:when(a:b)
    return a_time - b_time
endfunction

function s:is_terminal(buf)
    return getbufvar(a:buf, "&buftype") == "terminal"
endfunction

function s:recentbuffers()
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

    return sort(buffers, 's:buftimecmp')
endfunction

function Lst()
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

function TrimOldBuffers(count_to_trim)
    let recents = filter(s:recentbuffers(), { idx, buf -> !bufloaded(buf) })

    let count_to_trim = min([len(recents) - 1, a:count_to_trim])

    let delete = recents[:count_to_trim - 1]
    for i in delete
        execute "bdelete " . i
    endfor
    echo "Deleted " . len(delete) . " buffers"
endfunction

command Ls call Lst()
command -count=10 TrimOldBuffers call TrimOldBuffers(<count>)
