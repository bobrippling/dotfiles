set suffixesadd+=.py
let b:undo_ftplugin .= '|setlocal suffixesadd-=.py'

if exists("+tagfunc")
	setlocal tagfunc=PyTag
endif

function! JsTag(pattern, flags, info) abort
	" TODO: handle "r" in flags, i.e. `pattern` is a regex (`:tag /abc`)
	let based_on_normalmode_cursor = stridx(a:flags, "c") >= 0
	let for_completion =	stridx(a:flags, "i") >= 0

	if for_completion
		return []
	endif

	if based_on_normalmode_cursor
		let [tag, ident] = s:extended_tag_from_cursor()
	else
		" :tag, etc
		let [tag, ident] = s:maybe_split_tag_string(a:pattern)
	endif

	let import_line = s:import_search(tag)
	if import_line > 0
		" TODO:
		" - go up to `from`
		" - grab the module
		" - convert to path, handling `.` and `..` (`...`) prefixes
		" - try %:h/path, %:h:h/path, ...
		throw "todo"

		call s:debug("import line not found after tag")
	endif

	call s:debug("import line not found")
	return s:this_file_search(tag, ident)
endfunction

" ----------------------- copied from javascript.vim

function! s:debug(s) abort
	if 1
		echom "pytag: " . a:s " <--- changed from javascript.vim
	endif
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

		call cursor(cursor_list[1], dot) "dot: 0-based to 1-based
		let tag = expand("<cword>")

		call s:debug("dot: " . dot . ", ident: '" . ident . "', tag: '" . tag . "'")
	else
		let tag = expand("<cword>")
		let ident = tag
	endif

	return [tag, ident]
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
	call cursor(1, 1)
	" c: cursor pos accept, n: no move cursor, W: no wrap
	let found = search("\\C\\v^\\S[^'\"]*<" . a:tag . ">", "cnW")
	if found == 0
		call s:debug("couldn't find global decl for " . a:tag)
		return []
	endif

	return s:tag_in_this_file_on_line(a:tag, found)
endfunction

function! s:tag_in_this_file_on_line(tag, line) abort
	let thisfile = expand("%")

	if empty(thisfile)
		call s:emit_error("current buffer doesn't have a filename")
		return []
	endif

	return [{
	\   "name": a:tag,
	\   "filename": thisfile,
	\   "cmd": a:line, " <--- changed from javascript.vim
	\ }]
endfunction
