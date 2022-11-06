function! s:set(to, scope) abort
	execute "set" . a:scope . " grepprg=" . escape(a:to, ' \')
endfunction

function! s:setgrep(scope) abort
	if &filetype ==# 'javascript'
		let ignores = [
		\   '*.d',
		\   'node_modules/',
		\   '*.min.*',
		\   'dist/',
		\ ]
	elseif index(["c", "cpp", "objc", "objcpp"], &filetype) >= 0
		let ignores = ['*.o']
	else
		let ignores = []
	endif

	let path = exepath("rg")
	if !empty(path)
		let rgcommon = "rg --vimgrep"
		let where = ' $* /dev/null' " rg needs a dir, otherwise it searches stdin

		" Always case sensitive, no hidden variables
		"if &smartcase || &ignorecase
		"	let rgcommon .= " -i"
		"endif

		call map(ignores, { i, v -> "-g '!" . v . "'"})

		call s:set(rgcommon . " " . join(ignores) . where, a:scope)
		return
	endif

	let path = exepath("ag")
	if !empty(path)
		call map(ignores, { i, v -> "--ignore '" . v . "'"})

		call s:set("ag " . join(ignores), a:scope)
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
