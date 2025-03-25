function! OrgFoldText() abort
	let l = getline(v:foldstart)
	let stars = substitute(l, ' .*', '', '')
	let l = substitute(l, '^\*\+ *', '', '')

	let more = '     '

	for i in range(v:foldstart, v:foldend)
		if foldlevel(i) > v:foldlevel
			let more = ' ... '
			break
		endif
	endfor

	return stars . more . l
endfunction

function! s:orgzly_init()
	let w = GetDateOrgzly()
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

augroup org-manual
	autocmd!
	autocmd FileType org setl foldtext=OrgFoldText() fillchars-=fold:-
	\ | hi orgStrikethrough cterm=none gui=none

	autocmd FileType org
	\   nnoremap <buffer> gzu <Cmd>call <SID>orgzly_convert()<CR>
	\ | nmap <silent> <buffer> <expr> gzc ':<C-U>keeppatterns s/^\v\*+ \zs((TODO\|STARTED\|NEXT) )? */DONE /<CR>jgzC'
	\ | nnoremap <buffer> <expr> gzC 'ICLOSED: [' . GetDateOrgzly() . "] \<Esc>"
	\ | nnoremap <buffer> gzi <Cmd>call <SID>orgzly_init()<CR>
	\ | iabbrev <buffer> <expr> DONE getline('.') =~ '^\*' ? "\<Esc>gzc" : 'DONE'
augroup END

let g:org_state_keywords = ['TODO', 'NEXT', 'DONE', 'STARTED']
