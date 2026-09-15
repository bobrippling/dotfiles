function! ShTag(pattern, flags, info) abort
	let based_on_normalmode_cursor = stridx(a:flags, "c") >= 0
	let for_completion =	stridx(a:flags, "i") >= 0
	let is_regex = stridx(a:flags, "r") >= 0

	if for_completion
		return ShFileTags(based_on_normalmode_cursor ? a:pattern : "", is_regex)
	endif

	if based_on_normalmode_cursor
		let tag = expand("<cword>")
	else
		" :tag, etc
		let tag = a:pattern
	endif

	return s:tags_prefixed(tag, is_regex)
endfunction

function! ShFileTags(pattern, is_regex) abort
	return s:tags_prefixed(empty(a:pattern) ? '\S+' : a:pattern, empty(a:pattern) || a:is_regex)
endfunction

function s:tags_prefixed(prefix_pattern, is_regex) abort
	let thisfile = expand("%")
	if empty(thisfile)
		return []
	endif

	let pat = a:is_regex
	\ ? a:prefix_pattern
	\ : '^\<\V' .. substitute(a:prefix_pattern, '\', '&&', 'g')

	let tags = {}
	call cursor(line('$'), 0)
	while search('\C' . pat . '.*\m\(() *\|=\)', "bcW") > 0
		let lno = line(".")
		let line = getline(".")

		call cursor(lno - 1, 1)

		let tag = substitute(line, '[(=].*', '', '')
		let tags[tag] = lno
		if lno <= 1
			break
		endif
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
