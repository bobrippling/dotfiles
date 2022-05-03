function! s:set(to, scope) abort
	execute "set" . a:scope . " grepprg=" . escape(a:to, ' \')
endfunction

function! s:setgrep(scope) abort
	let path = exepath("rg")
	if !empty(path)
		let rgcommon = "rg --vimgrep -g '!_*/**'"
		let where = ' $* /dev/null' " rg needs a dir, otherwise it searches stdin

		if &smartcase || &ignorecase
			let rgcommon .= " -i"
		endif

		if &filetype ==# 'javascript'
			call s:set(
			\   rgcommon . " -g '!*.d' --ignore node_modules -g '!*.min.*' --ignore 'dist/**'" . where,
			\   a:scope
			\ )
		elseif index(["c", "cpp", "objc", "objcpp"], &filetype) >= 0
			call s:set(rgcommon . " -g '!*.o'" . where, a:scope)
		else
			call s:set(rgcommon . where, a:scope)
		endif

		return
	endif

	let path = exepath("ag")
	if !empty(path)
		let agcommon = "ag --depth 6 --ignore '_[^_]*/'"

		if &filetype ==# 'javascript'
			call s:set(agcommon . " --ignore '\*.d' --ignore node_modules --ignore '\*.min.\*' --ignore dist", a:scope)
		elseif index(["c", "cpp", "objc", "objcpp"], &filetype) >= 0
			call s:set(agcommon . " --ignore '\*.o'", a:scope)
		else
			call s:set(agcommon, a:scope)
		endif

		return
	endif

	setlocal grepprg&vim
	let &l:grepprg = substitute(&grepprg, '-', '-r', '')
endfunction

" set global grep, and then add autocmds for file-specific grep
call s:setgrep("")

augroup SetGrep
	autocmd!

	autocmd FileType * call s:setgrep("local")
augroup END
