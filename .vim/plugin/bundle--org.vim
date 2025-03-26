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

augroup org-manual
	autocmd!
	autocmd FileType org setl foldtext=OrgFoldText() fillchars-=fold:-
	\ | hi orgStrikethrough cterm=none gui=none

	autocmd FileType org iabbrev <buffer> <expr> DONE getline('.') =~ '^\*' ? "\<Esc>gzc" : 'DONE'
augroup END

let g:org_state_keywords = ['TODO', 'NEXT', 'DONE', 'STARTED']
