function! ShTag(pattern, flags, info) abort
	let based_on_normalmode_cursor = stridx(a:flags, "c") >= 0
	let for_completion =	stridx(a:flags, "i") >= 0

	if for_completion
		return ShFileTags(based_on_normalmode_cursor ? a:pattern : "")
	endif

	if based_on_normalmode_cursor
		let tag = expand("<cword>")
	else
		" :tag, etc
		let tag = a:pattern
	endif

	return s:tags_prefixed(tag)
endfunction

function! ShFileTags(pattern) abort
	return s:tags_prefixed(empty(a:pattern) ? '\S+' : a:pattern)
endfunction

function s:tags_prefixed(prefix_pattern) abort
	let thisfile = expand("%")
	if empty(thisfile)
		return []
	endif

	let tags = {}
	while search('\C^\<' . a:prefix_pattern . '.*\m\(() *\|=\)', "bcW") > 0
		let lno = line(".")
		let line = getline(".")

		call cursor(lno - 1, 1)

		let line = substitute(line, '[(=].*', '', '')
		let tags[line] = lno
	endwhile

	let ents = []
	for [t, lno] in items(tags)
		call add(ents, {
		\   "name": t,
		\   "filename": thisfile,
		\   "cmd": "call cursor(" . lno . ", 1)",
		\ })
	endfor

	return ents
endfunction

if exists("+tagfunc")
	setlocal tagfunc=ShTag
endif
