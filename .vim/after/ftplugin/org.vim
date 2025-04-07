" disable "first-only" "-" comment
" enable for -[], to mirror the orgzly app
setl comments-=fb:-
setl comments+=n:-,n:[,n:]

setl foldtext=OrgFoldText()
setl fillchars-=fold:-

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

function! OrgSearchNote() abort
	let at = getcmdpos() - 1

	return "\<Home>^\\*.*" . repeat("\<Right>", at)
endfunction

hi orgStrikethrough cterm=none gui=none

iabbrev <buffer> <expr> DONE getline('.') =~ '^\*' ? "\<Esc>gzc" : 'DONE'
cnoremap <buffer> <expr> <C-o> OrgSearchNote()
" ^ can't cabbrev: C-O isn't a word
