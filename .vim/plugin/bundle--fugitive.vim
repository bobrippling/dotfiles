function! s:handle_git_at(opts)
	let remote = a:opts.remote

	let url = substitute(remote, 'git@\([^:]\+\):', 'https://\1/', '')

	if url !=# remote
		return url
	endif
endfunction

function! s:handle_via_path2scm(opts)
	" opts.type: blob | ref | commit | tree
	" opts.path might be empty
	"
	" see also https://github.com/tpope/vim-fugitive/issues/1964

	if a:opts.type ==# "ref" || empty(a:opts.path)
		" browse to commit
		let type = "commit"
	elseif a:opts.type =~# '^\v(blob|tree|root)$'
		" browse to file/dir
		let type = a:opts.type
	else
		let type = "blob"
	endif

	try
		return Path2Scm_Url(a:opts.remote, a:opts.path, a:opts.commit, a:opts.line1, a:opts.line2, type)
	catch /unrecognised/
	endtry
endfunction

if !exists("g:fugitive_browse_handlers")
	let g:fugitive_browse_handlers = []
endif

" priority order
call add(g:fugitive_browse_handlers, function("s:handle_via_path2scm"))
call add(g:fugitive_browse_handlers, function("s:handle_git_at"))
