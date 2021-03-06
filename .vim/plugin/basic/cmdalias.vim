function! IsLoneCmd(cmd)
	if getcmdtype() != ':'
		return 0
	endif

	let range1 = "%(%([0-9%$]+|'.) *)?"
	let range = range1 . "%(," . range1 . ")?"

	let modifiers = '%(%(vert%[ical]|lefta%[bove]|abo%[veleft]|rightb%[elow]|bel%[owright]|to%[pleft]|bo%[tright]|' . range . ')\s+)*'

	let re = ('\v%(^|\|)[: \t]*' . modifiers . range . a:cmd)
	return getcmdline() =~ re
endfunction

function! CmdAlias(lhs, rhs)
	" Can't have a <silent> abbrev here, since as well as suppressing the
	" eventual command output, it also suppresses the expansion until the
	" next key press.
	exec "cnoreabbrev <expr> " . a:lhs . " IsLoneCmd('" . a:lhs . "') ? '" . a:rhs . "' : '" . a:lhs . "'"
endfunction

call CmdAlias('vsb', 'vert sb')
call CmdAlias('tabcp', 'tabc\|tabp')
call CmdAlias('tabb', 'tabnew\|b')

if has("nvim")
	call CmdAlias('ster', 'new\|ter')
	call CmdAlias('vter', 'vnew\|ter')
	" no alias for :ter - already expected behaviour
else
	call CmdAlias('ster', 'ter')
	call CmdAlias('vter', 'vert ter')
	call CmdAlias('ter', 'ter ++curwin')
endif
