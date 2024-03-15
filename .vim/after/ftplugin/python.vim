" 'define' and 'include[expr]' are set already by runtime/python.vim

set suffixesadd+=.py
let b:undo_ftplugin .= '|setlocal suffixesadd-=.py'

" indent for the next line
let g:pyindent_continue = 'shiftwidth()'
let g:pyindent_open_paren = 'shiftwidth()'
if exists('g:python_indent')
	let g:python_indent.closed_paren_align_last_line = v:false
endif

" overwrite runtime/python.vim's indentexpr:
function! s:set_indentexpr(...)
	let &l:indentexpr = 'GetPythonIndent_2(v:lnum)'
endfunction
call timer_start(25, function('s:set_indentexpr'))

if exists("+tagfunc")
	setlocal tagfunc=PyTag
endif

function! GetPythonIndent_2(lno)
	if getline(a:lno) =~ '^\s*[])]'
		return indent(a:lno - 1) - shiftwidth()
	endif

	return GetPythonIndent(a:lno)
endfunction

function! PyTag(pattern, flags, info) abort
	let based_on_normalmode_cursor = stridx(a:flags, "c") >= 0
	let for_completion = stridx(a:flags, "i") >= 0
	let is_re = stridx(a:flags, "r") >= 0

	if for_completion
		return s:pytags(a:pattern, is_re)
	endif

	" TODO: handle "r" in flags, i.e. `pattern` is a regex (`:tag /abc`)

	if based_on_normalmode_cursor
		let [tag, ident] = s:extended_tag_from_cursor()
	else
		" :tag, etc
		let [tag, ident] = s:maybe_split_tag_string(a:pattern)
	endif

	let [import_line_nr, _tag_line_nr] = s:import_search(tag)
	if import_line_nr > 0
		" - go up to `from`
		" - grab the module
		" - convert to path, handling `.` and `..` (`...`) prefixes
		" - try %:h/path, %:h:h/path, ...
		let import_line = getline(import_line_nr)

		if import_line[:3] ==# 'from'
			let mod = substitute(import_line, '^\vfrom\s+(\S+)\s+import\s+.*', '\1', '')
		else
			let mod = substitute(import_line, '^\vimport\s+(\S+)', '\1', '')
		endif

		let parts = split(mod, '\s\+as\s\+')
		if len(parts) == 2
			let mod = parts[0]
			"let alias = parts[1]
		endif

		" a.b -> a/b
		let mod = substitute(mod, '[^.]\zs\.\ze[^.]', '/', 'g')
		" .a -> ./a
		let mod = substitute(mod, '^\.\ze[^.]', './', 'g')

		let ndots = len(substitute(mod, '[^.].*', '', ''))
		if ndots > 0
			" ..a -> ../a
			" ...a -> ../../a
			let mod = substitute(mod, '^\.\+', repeat('../', ndots - 1), '')
		endif

		call s:debug("import, line: " . import_line . ", mod: " . mod) " . ', alias: ' . alias)

		let suff = expand("%:e")

		let is_fugitive = match(expand("%"), "^fugitive://") >= 0

		let i = 1
		while 1
			let base = expand("%" . repeat(":h", i))
			if empty(base)
				let base = "."
			endif

			let no_suff = base . '/' . mod
			let candidate = no_suff . '.' . suff

			if is_fugitive
				let readable = !empty(fugitive#glob(candidate))
			else
				let readable = filereadable(candidate)
			endif

			call s:debug("i=" . i . " trying \"" . candidate . "\": readable=" . readable)
			if readable
				return [{
				\   "name": tag,
				\   "filename": candidate,
				\   "cmd": 'call PyTagInCurFile("' . ident . '")',
				\ }]
				" '/^\S.*\<' . ident . '\>/',
				" ^ this gives E435
			endif

			if is_fugitive
				let readable_dir = !empty(fugitive#glob(no_suff))
			else
				let readable_dir = isdirectory(no_suff)
			endif
			if readable_dir
				call s:debug("i=" . i . " isdirectory(\"" . no_suff . "\")=1, tag=\"" . tag . "\"")
				return [{
				\   "name": tag,
				\   "filename": no_suff . "/" . tag . '.' . suff,
				\   "cmd": 'call PyTagInCurFile("' . ident . '")',
				\ }]
			endif

			if base ==# "." || base ==# "/"
				break
			endif
			let i += 1
		endwhile

		" findfile() doesn't seem to work with upward search
		"call s:debug("looking for " . mod . " with " . &suffixesadd . " in folders above/incl. " . expand('%:h'))
		"let f = findfile(mod, expand('%:h') . ';')
		""                     ^~~~~~~~~~~~    ^~~
		""                     search start    stop here
		"if !empty(f)
		"	return [{
		"	\   "name": tag,
		"	\   "filename": f,
		"	\   "cmd": '/^\S.*\<' . ident . '\>',
		"	\ }]
		"endif

		call s:debug("couldn't find module \"" . mod . "\" above \"" . expand("%:h") . "\"")
	else
		call s:debug("import line for \"" . tag . "." . ident . "\"not found")
	endif

	return s:this_file_search(tag, ident)
endfunction

function! s:pytags(pattern, is_re)
	let tags = []
	let curbuf = expand("%")

	for i in range(1, line("$"))
		let line = getline(i)
		let matches = matchlist(line, '^\v\s*%(class|def)\s+([a-zA-Z_][a-zA-Z0-9_]*)')

		if len(matches) && len(matches[1])
			if a:is_re
				if matches[1] !~# a:pattern
					continue
				endif
			else
				if !empty(a:pattern) && matches[1][:len(a:pattern)-1] !=# a:pattern
					continue
				endif
			endif

			call extend(tags, s:tag_in_this_file_on_line_col(matches[1], i, 1))
		endif
	endfor

	return tags
endfunction

function! PyTagInCurFile(ident)
	keepjumps normal! gg0

	" c: accept match at cursor
	" W: no wrap around
	if search('\C\v<' . a:ident . '>', 'cw') == 0
		call s:emit_error("Couldn't find " . a:ident)
	endif
endfunction

function! s:import_search(name)
	" c: cursor pos accept, n: no move cursor, w: wrap, b: backwards

	" look for "as <name>" first
	let found = search("\\C\\v^(from|import)\\s+.*<as>\\s+<" . a:name . ">", "cnwb")
	if found > 0
		return [found, found]
	endif

	call s:debug("'as' import not found, looking for normal...")

	" look for no "as"
	let found = search("\\C\\v^(from|import)\\s+.*<" . a:name . ">", "cnwb")
	if found > 0
		return [found, found]
	endif

	call s:debug("oneline import not found, looking for multiple...")

	let linenr = 0
	let tag_linenr = 0
	for i in range(1, line("$"))
		let line = getline(i)
		if line =~? '^\v(import|from).*\(\s*$'
			" started parens
			let linenr = i
		elseif linenr
			if line =~ '^)'
				let linenr = 0
			else
				if line =~# '\v<' . a:name . '>'
					let found = 1
					break
				endif
			endif
		endif
	endfor

	return tag_linenr > 0 ? [linenr, tag_linenr] : [0, 0]
endfunction

" ----------------------- copied from javascript.vim

function! s:debug(s) abort
	if 0
		echom "pytag: " . a:s
		" ^--- changed from javascript.vim
	endif
endfunction

function! s:emit_error(msg)
	echohl ErrorMsg
	echo a:msg
	echohl None
endfunction

function! s:extended_tag_from_cursor() abort
	let cursor_list = getcurpos() " buffer,line,col,off,curswant
	let line = getline(".")
	let dot = strridx(line, '.', cursor_list[2]-1)

	call s:debug("finding dot in '" . line . "', starting at " . dot)

	if dot >= 0
		let dot_to_tag = strpart(line, dot+1, cursor_list[2] - (dot+1))
		call s:debug("dot_to_tag: '" . dot_to_tag . "'")
		if !s:contains_only_iskeyword_chars(dot_to_tag)
			" we're somewhere like "abc.xyz = hello"
			"																		^
			" and have found the dot before
			let dot = -1
		endif
	endif

	if dot >= 0
		let ident = expand("<cword>")

		" keep jumps?
		call cursor(cursor_list[1], dot) "dot: 0-based to 1-based
		let tag = expand("<cword>")

		call s:debug("dot: " . dot . ", ident: '" . ident . "', tag: '" . tag . "'")
	else
		let tag = expand("<cword>")
		let ident = tag
	endif

	return [tag, ident]
endfunction

function! s:contains_only_iskeyword_chars(str) abort
	return empty(a:str) || match(a:str, "^\\k\\+$") == 0
endfunction

function! s:maybe_split_tag_string(str) abort
	let dot = stridx(a:str, '.')

	if dot >= 0
		let tag = a:str[:dot-1]
		let ident = a:str[dot+1:]
	else
		let tag = a:str
		let ident = a:str
	endif

	return [tag, ident]
endfunction

function! s:this_file_search(tag, ident) abort
	" look for tag, ignore ident (for now)
	keepjumps normal! gg0
	" c: cursor pos accept, n: no move cursor, W: no wrap
	let [line, col] = searchpos("\\C\\v^\\S[^'\"]*<\\zs" . a:tag . ">", "cnW")
	if line == 0 && col == 0
		call s:debug("couldn't find global decl for " . a:tag)
		return []
	endif

	return s:tag_in_this_file_on_line_col(a:tag, line, col)
endfunction

function! s:tag_in_this_file_on_line_col(tag, line, col) abort
	" ^--- signature changed from javascript.vim
	let thisfile = expand("%")

	if empty(thisfile)
		call s:emit_error("current buffer doesn't have a filename")
		return []
	endif

	call s:debug("this_file: tag=" . a:tag . ", f: " . thisfile . ", line: " . a:line)

	return [{
	\   "name": a:tag,
	\   "filename": thisfile,
	\   "cmd": ":" . a:line . " | normal! " . a:col . "|",
	\ }]
	" ^--- `cmd`: changed from javascript.vim
endfunction
