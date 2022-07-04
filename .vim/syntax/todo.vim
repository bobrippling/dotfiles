syn match Comment /\/\/.*/
syn match Separator /^--\+/

"hi Comment
hi Separator ctermfg=green

" --------------

syn match TodoBacklog /\[ \].*/
syn match TodoInProgress /\[\.\].*/
syn match TodoBlocked /\[-\].*/
syn match TodoDone /\[x\].*/

hi TodoBacklog ctermfg=green
hi TodoInProgress ctermfg=yellow
hi TodoBlocked ctermfg=red
hi TodoDone ctermfg=blue

function! TodoFold(lno)
	let prior = getline(a:lno - 1)
	let line = getline(a:lno)

	" previous line was start of a section? +1
	if prior =~# '^\S\|:\s*$'
		return 'a1'
	endif
	" current line is the beginning? 1
	if line =~# '^\S'
		return 1
	endif

	" empty? end of section? 0, otherwise match previous line
	if empty(line)
		for i in range(a:lno + 1, line('$'))
			let l = getline(i)
			if l =~# '^\S'
				return 0
			elseif !empty(l)
				break
			endif
		endfor
		return '='
	endif

	" indented? (and impliciyly no /:$/) match previous line
	if line[0] =~# '\s'
		return '='
	endif

	" undefined
	return -1
endfunction

setl foldexpr=TodoFold(v:lnum)
setl foldmethod=expr
