function! s:set(to, scope) abort
	execute "set" . a:scope . " grepprg=" . escape(a:to, ' \')
endfunction

function! s:setgrep(scope) abort
	if exepath("ag") != ""
		let agcommon = "ag --depth 6 --ignore '_[^_]*/'"

		if &filetype ==# 'javascript'
			call s:set(agcommon . " --ignore '\*.d' --ignore node_modules --ignore '\*.min.\*' --ignore dist", a:scope)
			return

		elseif index(["c", "cpp", "objc", "objcpp"], &filetype) >= 0
			call s:set(agcommon . " --ignore '\*.o'", a:scope)
			return

		endif

		call s:set(agcommon, a:scope)
		return
	endif

	setlocal grepprg&vim
endfunction

" set global grep, and then add autocmds for file-specific grep
call s:setgrep("")

augroup SetGrep
	autocmd!

	autocmd FileType * call s:setgrep("local")
augroup END
