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
			return 0
		endtry
	endif
endfunction

function! s:latest_modified_first(a, b)
	let a_time = s:when(a:a)
	let b_time = s:when(a:b)
	return b_time - a_time
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
	return sort(s:buffers(), 's:latest_modified_first')
endfunction

function! Lst()
	for i in s:recentbuffers()
		let when = s:when(i)

		if when == 0
			let when = "<unknown time>"
		else
			let when = strftime("%Y-%d-%m %H:%M", when)
		endif
		echon "[" . i . "]\t"
		if bufloaded(i)
			echohl Pmenu
		endif
		echon when . "\t" . bufname(i) . "\n"
		echohl NONE
	endfor
endfunction

function! TrimOldBuffers(count, bang)
	" bang = true: keep `count` many buffers
	" bang = false: remove `count` many buffers
	let recents = filter(s:recentbuffers(), { idx, buf -> !bufloaded(buf) })

	if a:bang
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

function! TrimUnlinkedBuffers(bang)
	let curbuf = bufnr("")
	let newwin = 0
	let delete = []

	for buf in s:buffers()
		let name = bufname(buf)
		if empty(name) || !empty(getbufvar(buf, "&buftype")) || stridx(name, "://") >= 0
			continue
		endif

		" if buffer open, ignore (unless -bang)
		if !a:bang
			let bufopen = bufwinid(buf) != -1
			if bufopen | continue | endif
		endif

		if s:fileexists(name)
			continue
		endif

		call add(delete, buf)

		if buf ==# curbuf
			let newwin = 1
		endif
	endfor

	if empty(delete)
		echom "No unlinked buffers"
		return
	endif

	if newwin
		botright new
	endif

	let names = map(copy(delete), { _, x -> bufname(x) })

	execute "bdelete " . join(delete)

	echom "Removed unlinked buffers:"
	for name in names
		echom "  " name
	endfor
endfunction

command! Ls call Lst()
command! -bang -count=10 TrimOldBuffers call TrimOldBuffers(<count>, <bang>0)
command! -bang TrimUnlinkedBuffers call TrimUnlinkedBuffers(<bang>0)
