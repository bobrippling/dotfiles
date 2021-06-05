"function! ObsessionPost_RestoreTabNames() abort
"endfunction
"
"let g:obsession_append += ['call ObsessionPost_RestoreTabNames()']

function! s:append_vars() abort
	if !exists('g:this_obsession')
		return
	endif

	let body = readfile(g:this_obsession)

	for t in range(1, tabpagenr("$"))
		let title = gettabvar(t, "title")
		if !empty(title)
			let escaped_title = substitute(title, "'", "\\'", "g")
			call insert(body, 'call settabvar(' . t . ', "title", "' . escaped_title . '")', -3)
		endif
	endfor

	call writefile(body, g:this_obsession)
endfunction

augroup ObsessionPost
	autocmd!
	autocmd User Obsession call s:append_vars()
augroup END
