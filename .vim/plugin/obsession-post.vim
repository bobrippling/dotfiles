function! s:append_vars() abort
	if !exists('g:this_obsession')
		return
	endif

	" TODO? don't clear here, append in other files instead?
	let g:obsession_append = []

	for t in range(1, tabpagenr("$"))
		let title = gettabvar(t, "title")
		if !empty(title)
			let escaped_title = substitute(title, "'", "\\'", "g")
			let g:obsession_append += ['call settabvar(' . t . ', "title", "' . escaped_title . '")']
		endif
	endfor

	if exists('g:autosave_enabled')
		let g:obsession_append += ['let g:autosave_enabled = ' . g:autosave_enabled]
	endif
endfunction

augroup ObsessionPost
	autocmd!
	autocmd User ObsessionPre call s:append_vars()
augroup END
