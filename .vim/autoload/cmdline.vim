function! s:get_re(cmd)
	if getcmdtype() != ':'
		return 0
	endif

	let range1 = "%(%([0-9%$]+|'.) *)?"
	let range = range1 . "%(," . range1 . ")?"

	let modifiers = '%(%(vert%[ical]|lefta%[bove]|abo%[veleft]|rightb%[elow]|bel%[owright]|to%[pleft]|bo%[tright]|' . range . ')\s+)*'

	" TODO: getcmdpos for better matching
	return '\v%(^|\|)[: \t]*' . modifiers . range . '%(' . a:cmd . ')'
endfunction

function! cmdline#matching(cmd)
	let re = s:get_re(a:cmd)
	return matchlist(getcmdline(), re)
endfunction

function! cmdline#matches_cmd(cmd)
	let re = s:get_re(a:cmd)
	return getcmdline() =~ re
endfunction

