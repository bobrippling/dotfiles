function! s:set(to) abort
	execute "setlocal grepprg=" . escape(a:to, ' \')
endfunction

function! s:setgrep() abort
	if exepath("ag") != ""
		let agcommon = "ag --depth 6 --ignore '_[^_]*/'"

		if &filetype ==# 'javascript'
			call s:set(agcommon . " --ignore '\*.d' --ignore node_modules --ignore '\*.min.\*' --ignore dist")
			return

		elseif index(["c", "cpp", "objc", "objcpp"], &filetype) >= 0
			call s:set(agcommon . " --ignore '\*.o'")
			return

		endif

		call s:set(agcommon)
		return
	endif

	setlocal grepprg&vim
endfunction

augroup SetGrep
	autocmd!

	autocmd FileType * call s:setgrep()
augroup END
