let s:ignore_next = 0

function! s:get_date()
	let s:ignore_next = 1
	return strftime("%Y-%m-%d")
endfunction

function! GetDateOrgzly()
	return strftime("%Y-%m-%d %a %H:%M")
endfunction

function! s:get_time()
	return strftime("%H:%M")
endfunction

function! s:orgzly_convert()
"	let [_, line, col, off] = getpos(".")
"	let t = getline(line)
"
"	let start = col
"	while start > 0 && match(t[start-1], '[0-9-]') >= 0
"		let start -= 1
"	endwhile
"	let end = col
"	while end <= len(t) && match(t[end-1], '[0-9-]') >= 0
"		let end += 1
"	endwhile
"
"	let d = t[start : end-2]
"
"	echom "start" start
"	echom "end" end
"
"	return "i>" . d . "<\<Esc>"
	let p = getcurpos()
	keeppatterns s/\v(\d{4}-\d{2}-\d{2}) [A-Z][a-z]+>/\=strftime("%Y-%m-%d %a", strptime("%Y-%m-%d", submatch(1)))/g
	call setpos(".", p)
endfunction

function! s:orgzly_init()
	let w = s:get_date_orgzly()
	let lines = [
	\   'SCHEDULED: <' . w . '>',
	\   ':PROPERTIES:',
	\   ':CREATED:  [' . w . ']',
	\   ':END:',
	\   ''
	\ ]
	call append(line('.'), lines)

	mark [
	keepjumps +5
	mark ]
	keepjumps -5
endfunction

cnoremap <expr> <C-R><C-D> <SID>get_date() . '-'
inoremap <expr> <C-R><C-D> <SID>get_date()

cnoremap <expr> <C-R><C-Z> GetDateOrgzly() . '-'
inoremap <expr> <C-R><C-Z> GetDateOrgzly()

cnoremap <expr> <C-R><C-T> <SID>get_time() . '-'
inoremap <expr> <C-R><C-T> <SID>get_time()

nnoremap <buffer> gzu <Cmd>call <SID>orgzly_convert()<CR>
nmap <silent> <buffer> <expr> gzc ':<C-U>keeppatterns s/^\v\*+ \zs((TODO\|STARTED\|NEXT) )?/DONE /<CR>jgzC'
nnoremap <buffer> <expr> gzC 'ICLOSED: [' . <SID>get_date_orgzly() . "] \<Esc>"
nnoremap <buffer> gzi <Cmd>call <SID>orgzly_init()<CR>
iabbrev <buffer> <expr> DONE getline('.') =~ '^\*' ? "\<Esc>gzc" : 'DONE'

if 0
	function! s:check_date_typed()
		let now_re = strftime("\\v%Y.?%m.?%d")
		let cmd = getcmdline()

		let [matched, start, end] = matchstrpos(cmd, now_re)
		if start ==# -1
			return
		endif

		if s:ignore_next
			let s:ignore_next = 0
			return
		endif

		let where = getcmdpos() - 1
		if end ==# where
			throw "You can use <C-R><C-D> for the date"
		endif
	endfunction

	augroup CmdDate
		autocmd!
		autocmd CmdlineChanged * call s:check_date_typed()
	augroup END
endif
