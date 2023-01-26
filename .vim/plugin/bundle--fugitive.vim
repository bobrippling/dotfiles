function! s:handle_git_at(opts)
	let remote = a:opts.remote

	let url = substitute(remote, 'git@\([^:]\+\):', 'https://\1/', '')

	if url !=# remote
		return url
	endif
endfunction

function! s:handle_via_path2scm(opts)
	try
		return Path2Scm_Url(a:opts.remote, a:opts.path, a:opts.commit, a:opts.line1, a:opts.line2)
	catch /unrecognised/
	endtry
endfunction

if !exists("g:fugitive_browse_handlers")
	let g:fugitive_browse_handlers = []
endif

" priority order
call add(g:fugitive_browse_handlers, function("s:handle_via_path2scm"))
call add(g:fugitive_browse_handlers, function("s:handle_git_at"))
