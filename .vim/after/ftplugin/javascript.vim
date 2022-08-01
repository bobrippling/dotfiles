" 'define' is set already by runtime/javascript.vim

let s:unknown = 'require and/or from'
let s:is_require = 'require'
let s:is_import = 'from'

function! s:debug(s) abort
	if 0
		echom "jstag: " . a:s
	endif
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

function! s:emit_error(msg)
	echohl ErrorMsg
	echo a:msg
	echohl None
endfunction

function! JsTagInCurFile(ident) abort
	keepjumps if searchdecl(a:ident, 1) == 0
		return
	endif

	" not found via searchdecl

	" - can't do ijump in a sandbox, emulate below instead
	"execute "ijump " . a:ident

	call cursor(1, 1)
	" c: accept match at cursor
	" W: no wrap around
	" z: start at cursor column
	if search("\\C\\v<" . a:ident . ">", "cw") == 0
		call s:emit_error("Couldn't find " . a:ident)
	endif
endfunction

function! JSTagOnLine(line, tag)
	let line = getline(a:line)
	let escaped_tag = substitute(a:tag, '\\', '\\\\', 'g')
	let x = "\\C\\<\\V" . escaped_tag . "\\m\\>"
	let col = match(line, x)
	"                            ^~~ very nomagic      ^~~ restore magic/normal re

	call cursor(a:line, 1 + (col >= 0 ? col : 0))
endfunction

function! s:try_js_index(nextfile, path) abort
	let nextfile = a:nextfile

	if empty(nextfile)
		let nextfile = expand("%:h")
	endif

	let found = findfile(nextfile . "/index", a:path)

	call s:debug("js-index, findfile(" . nextfile . " + '/index', <path>): " . found
				\ . " (with path = " . a:path . ")")

	if !empty(found)
		return found
	endif
	return nextfile
endfunction

function! s:trim_dotdots(path) abort
	let path = a:path
	let updirs = 0
	while match(path, "^\\.\\./") >= 0
		let path = substitute(path, "^\\.\\./", "", "")
		let updirs += 1
	endwhile
	return [updirs, path]
endfunction

function! s:file_from_import_virtual(nextfile) abort
	let nextfile = a:nextfile

	if match(nextfile, "^\\.") >= 0
		" relative to current path
		call s:debug("file_from_import_virtual, relative nextfile (" . nextfile . ")")

		let [updirs, nextfile] = s:trim_dotdots(nextfile)

		let base = expand("%:h" . repeat(":h", updirs))
					\ . "/"
					\ . substitute(nextfile, "^\\./", "", "")
	else
		call s:debug("file_from_import_virtual, absolute nextfile (" . nextfile . ")")

		" fugitive://<path-to-repo>/.git//<hash>/<path-to-file>/<file>
		"                                        ^~~~~~~~~~~~~~~~~~~~~ discard
		let components = split(expand("%"), "/")
		let git_pos = index(components, ".git")

		if git_pos == -1
			throw "couldn't figure out target import for '" . nextfile . "'"
		endif
		let target_dir = join(components[:git_pos + 2], "/")

		let base = target_dir . "/" . nextfile
	endif

	" candidate extensions, can't tell/use suffixesadd directly because it's in git
	let exts = split(&suffixesadd , ",")
	call uniq(sort(exts))

	" add the most likely first, for speed:
	let cur = expand("%:e")
	let cur_without_x = substitute(cur, "x$", "", "") " tsx --> ts
	if cur_without_x !=# cur
		call insert(exts, "." . cur_without_x)
	endif
	call insert(exts, "." . cur)

	call s:debug("file_from_import_virtual, trying with exts: " . join(exts, ", "))

	for index in ['', '/index']
		for ext in exts
			let candidate = base . index . ext
			if !empty(fugitive#glob(candidate))
				return candidate
			endif
		endfor
	endfor

	return base . "." . cur
	"                   ^~~~~~~~~~~~~ just match the current file
endfunction

function! s:file_from_import(nextfile) abort
	" this function needs to do the equivalent of 'gf', which isn't the same as findfile()
	let nextfile = a:nextfile

	if match(expand("%"), "^fugitive://") >= 0
		" not an actual file, just try to interpolate ourselves
		return s:file_from_import_virtual(nextfile)
	endif

	" findfile() doens't work on paths like "./abc" - remove prefix
	let nextfile = substitute(nextfile, "^\\./", "", "")

	" findfile() doesn't work on paths like "../abc" - remove prefix and expand path
	let [updirs, nextfile] = s:trim_dotdots(nextfile)
	let pathexpand = ""
	if updirs > 0
		let updirs += 1 " if we're doing a relative fix, chop off the filename first
		let pathexpand = repeat(":h", updirs)
	endif

	" put current file's directory first, for priority
	let path = expand("%" . pathexpand) . "," . &path
	call s:debug("main findfile('" . nextfile . "', path) with path = '%" . pathexpand . "' ('" . path . "')")
	let found = findfile(nextfile, path)
	if empty(found)
		call s:debug("nothing found, trying js-index...")
		let nextfile = s:try_js_index(nextfile, path)
	else
		call s:debug("found '" . found . "'")
		let nextfile = found
	endif

	return nextfile
endfunction

function! s:generate_cmd(cmd) abort
	" must :keepjumps inside a:cmd
	return "keepjumps " . a:cmd
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
	\   "cmd": s:generate_cmd("call JSTagOnLine(" . a:line . ", '" . a:tag . "')"),
	\ }]
endfunction

function! s:scoped_tag_search(ident) abort
	" b: backwards, n: no cursor move, W: nowrapscan
	" r: keep going to the outer most (this is probably easier than trying to look for a function body
	let start_line = searchpair("{", "", "}", 'bnWr')
	if start_line <= 0
		call s:debug("couldn't find block start for " . tag . "." . ident)
		return []
	endif

	let end_line = searchpair("{", "", "}", 'nWr')
	if end_line <= 0
		call s:debug("couldn't find block end for " . tag . "." . ident)
		return []
	endif

	call cursor(start_line, 0)
	" c: cursor pos accept, n: no move cursor, W: no wrap
	let found = search("^\\C\\v\\s*((async|\*|public|private) *)*<" . a:ident . ">", "cnW", end_line)
	if found == 0
		call s:debug("couldn't find " . a:ident . " in " . start_line . "," . end_line)
		return []
	endif

	call s:debug("found local ident between " . start_line . "," . end_line . " on line " . found)

	return s:tag_in_this_file_on_line(a:ident, found)
endfunction

function! s:this_file_search(tag, ident) abort
	" look for tag, ignore ident (for now)
	keepjumps normal! gg0
	" c: cursor pos accept, n: no move cursor, W: no wrap
	let found = search("\\C\\v^\\S[^'\"]*<" . a:tag . ">", "cnW")
	if found == 0
		call s:debug("couldn't find global decl for " . a:tag)
		return []
	endif

	return s:tag_in_this_file_on_line(a:tag, found)
endfunction

function! s:tag_from_stringpath(found_line, ident)
	" search forward to handle cases like import ... from 'abc'; // 'avoid matching here'
	let line = getline(a:found_line)
	let nextfile = matchstr(line, "\\v\\C(['\"])\\zs(.*)\\ze\\1")
	if nextfile == line
		" failed to extract filename
		call s:debug("couldn't extract filename from import/require line")
		return []
	endif

	let nextfile = s:file_from_import(nextfile)

	return [{
	\		 "name": a:ident,
	\		 "filename": nextfile,
	\		 "cmd": s:generate_cmd("call JsTagInCurFile('" . a:ident . "')"),
	\ }]
endfunction

function! s:import_require_search(tag) abort
	" find the line that contains the string path import
	" returns [lineno, s:{is_require|is_import|unknown}]
	"
	" we could return [..., tag] for tags that are renamed, i.e. '{ x as y }'
	let tag = a:tag

	call s:debug("looking for import + " . tag)
	let import_search = "\\C^import[^'\"]*\\<" . tag . "\\>"
				\ . "\\|"
				\ . "^export[^'\"]*\\<" . tag . "\\>.*\\<from\\>"

	" w: wrap around, c: accept match at cursor
	let found_line = search(import_search, "wc")
	if found_line > 0
		return [found_line, s:is_import]
	endif

	call s:debug("looking for require + " . tag)
	let require_search = "\\v\\C^(const|let|var)>[^'\"]*<" . tag . ">.*\\=.*<require>"
	let found_line = search(require_search, "wc")
	if found_line > 0
		return [found_line, s:is_require]
	endif

	" look for import { \n <...> \n } from '<path>'
	" (don't anchor to EOL, we want to allow comments, etc)
	let tag_search = "\\v\\C^(\\s*type )?\\s*([a-zA-Z0-9_$]+\\s+as\\s+)?<" . tag . ">\\s*,?"
	call cursor(1, 1)
	let found_line = search(tag_search, "Wc")

	call s:debug("looking for " . tag . " inside {...} (with " . tag_search . ") - line = " . found_line)

	if found_line > 0
		call s:debug("found on line " . found_line . ", searching for end of imports...")
		let skip_search = "\\v\\C^(\\s*type )?\\s*([a-zA-Z0-9_$]+\\s+as\\s+)?<[a-zA-Z0-9]+>\\s*,?"
		while 1
			let line = getline(found_line)
			if match(line, skip_search) < 0
				break
			endif
			let found_line += 1
		endwhile

		" we've found the line of the import, leave it to the caller
		" to find the `from '...'` line
		call s:debug("import-end found at line " . found_line)

		" v:true - could be either require or import
		" pretend it's require and just look for a string
		return [found_line, s:unknown]
	endif

	return [0, s:unknown]
endfunction

function! s:from_line_after_import_line(import_line, import_kind) abort
	let start = a:import_line
	let i = start
	let end = start + 10 " search up to this many lines after, for the require/from '...' part

	if a:import_kind == s:is_require
		let re = "\\v\\C<require>.*(['\"]).*\\1"
	elseif a:import_kind == s:is_import
		let re = "\\v\\C<from>\\s+['\"]"
	elseif a:import_kind == s:unknown
		let re = "\\v\\C<(require\\s*\\(|from\\s)\\s*['\"]"
	else
		throw "unknown enum"
	endif

	call s:debug("looking for require/from (" . a:import_kind . "), lines " . i . "-" . end)

	while i <= end
		let line = getline(i)

		if match(line, re) >= 0
			call s:debug("found, line " . i)
			return i
		elseif i > start && match(line, "\\C\\v<(import|require|export)>") >= 0
			" found a new import, 'from' for the previous doesn't exist
			call s:debug("new import found, line " . i . ", aborting search")
			break
		endif

		let i += 1
	endwhile

	return 0
endfunction

function! JsTag(pattern, flags, info) abort
	" TODO: handle "r" in flags, i.e. `pattern` is a regex (`:tag /abc`)
	let based_on_normalmode_cursor = stridx(a:flags, "c") >= 0
	let for_completion =	stridx(a:flags, "i") >= 0

	if for_completion
		return JsFileTags(based_on_normalmode_cursor ? a:pattern : "")
	endif

	if based_on_normalmode_cursor
		let [tag, ident] = s:extended_tag_from_cursor()
	else
		" :tag, etc
		let [tag, ident] = s:maybe_split_tag_string(a:pattern)
	endif

	" check here, so we support `:tag this.func`, as well as normal-mode maps
	if tag !=# ident && tag ==# "this"
		return s:scoped_tag_search(ident)
	endif

	let [found_line, import_kind] = s:import_require_search(tag)
	if found_line > 0
		let from_line = s:from_line_after_import_line(found_line, import_kind)

		if from_line > 0
			return s:tag_from_stringpath(from_line, ident)
		endif
		call s:debug("'" . import_kind . "' line not found after tag")
	endif

	call s:debug("import/require line not found")
	return s:this_file_search(tag, ident)
endfunction

function! JsFileTags(pattern) abort
	let import_search = "\\v\\C^import[^'\"]+"
	let [buf; save_cursor] = getcurpos()

	let allents = []
	let flags = "cWz"
	let lnum = 0
	while 1
		call cursor(lnum + 1, 0)
		let lnum = search(import_search, flags)
		if lnum <= 0
			break
		endif

		let line = getline(lnum)
		let filename = substitute(line, "\\v\\C.*from (['\"])([^'\"]+)\\1.*", "\\2", "")
		let ent_str = substitute(line, "\\v\\C^import (.*) from.*", "\\1", "")
		let ents = filter(split(ent_str, "\\s*[{},]\\s*", 0), "!empty(v:val)")

		for ent in ents
			let ent = substitute(ent, "\\C\\v.* as (.*)", "\\1", "")

			if match(ent, a:pattern) < 0
				continue
			endif

			let allents += [{
			\		 "name": ent,
			\		 "filename": filename,
			\		 "cmd": s:generate_cmd("call JsTagInCurFile('" . ent . "')"),
			\ }]
		endfor
	endwhile

	call cursor(save_cursor)

	return allents
endfunction

function! s:test(enable) abort
	let [buf; save_cursor] = getcurpos()
	if a:enable
		keeppatterns keepjumps silent %s;^\s*\zsxit\ze(;it;
	else
		keeppatterns keepjumps silent %s;^\s*\zsit\ze(;xit;
	endif
	call cursor(save_cursor)
endfunction

command! SpecDisable call s:test(0)
command! SpecEnable  call s:test(1)

if exists("+tagfunc")
	setlocal tagfunc=JsTag
endif

setlocal suffixesadd+=.js,.jsx
setlocal spelloptions+=camel

setlocal indentexpr=

setlocal omnifunc=Dotcomplete
" if we're not noselect/noinsert, then step back to avoid auto-inserting on `.`
"inoremap <expr> <buffer> . '.<C-X><C-O>' .. (&completeopt =~? '\vno(select\|insert)' ? '' : '<C-E>')

if exists('b:undo_ftplugin')
	if exists('b:undo_ftplugin')
		let b:undo_ftplugin .= '|setlocal tagfunc<'
	endif

	let b:undo_ftplugin .= '|setlocal suffixesadd<'
	let b:undo_ftplugin .= '|setlocal spelloptions<'
	let b:undo_ftplugin .= '|setlocal indentexpr<'

	let b:undo_ftplugin .= '|setlocal omnifunc<'
	"let b:undo_ftplugin .= '|iunmap <buffer> .'
endif

if exists(":packadd")
	" html matching
	packadd matchit

	" stolen from html.vim:
	let b:match_words = '<:>,<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif
