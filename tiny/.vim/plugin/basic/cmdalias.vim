function! IsLoneCmd(cmd)
	if getcmdtype() != ':'
		return 0
	endif

	let modifiers = '((vert%[ical]|lefta%[bove]|abo%[veleft]|rightb%[elow]|bel%[owright]|to%[pleft]|bo%[tright])\s+)*'
	return getcmdline() =~ ('\v(^|\|)\s*' . modifiers . a:cmd)
endfunction

function! CmdAlias(lhs, rhs)
	exec "cnoreabbrev <silent> <expr> " . a:lhs . " IsLoneCmd('" . a:lhs . "') ? '" . a:rhs . "' : '" . a:lhs . "'"
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
	call CmdAlias("ter", "ter ++curwin")
endif
