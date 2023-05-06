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

	if executable("rg")
		let rgcommon = "rg --vimgrep"
		let where = ' $* /dev/null' " rg needs a dir, otherwise it searches stdin

		" Always case sensitive, no hidden variables
		"if &smartcase || &ignorecase
		"	let rgcommon .= " -i"
		"endif

		call map(ignores, { i, v -> "-g '!" . v . "'"})

		call s:set(rgcommon . " " . join(ignores) . where, a:scope)
		" from jon-g:
		exe "set".a:scope "grepformat=%f:%l:%c:%m"
		return
	endif

	if executable("ag")
		call map(ignores, { i, v -> "--ignore '" . v . "'"})

		call s:set("ag " . join(ignores), a:scope)
		return
	endif

	setlocal grepprg&vim
	let &l:grepprg = substitute(&grepprg, '-', '-r', '')
endfunction

function! s:checkrg()
	let qflist = getqflist()
	for ent in qflist
		if ent.valid
			return
		endif
	endfor

	echohl WarningMsg
	try
		echom "Warning: grep returned nothing and may have been invoked with just /dev/null"
	finally
		echohl none
	endtry
endfunction

" set global grep, and then add autocmds for file-specific grep
call s:setgrep("")
let s:in_qf = 0

augroup SetGrep
	autocmd!

	autocmd FileType * call s:setgrep("local")
	autocmd ShellCmdPost * if s:in_qf | call s:checkrg() | endif
	autocmd QuickFixCmdPre * let s:in_qf = 1
	autocmd QuickFixCmdPost * let s:in_qf = 0
augroup END
