function! CmdAlias(lhs, rhs)
	" Can't have a <silent> abbrev here, since as well as suppressing the
	" eventual command output, it also suppresses the expansion until the
	" next key press.
	exec "cnoreabbrev <expr> " . a:lhs . " <SID>matches_cmd('" . a:lhs . "') ? '" . escape(a:rhs, '|\') . "' : '" . a:lhs . "'"
endfunction

function! s:matches_cmd(lhs)
	try
		return cmdline#matches_cmd(a:lhs)
	catch /E117/ " Unknown function
		return 0
	endtry
endfunction

call CmdAlias('vsb', 'vert sb')
call CmdAlias('tabcp', 'tabc|tabp')
call CmdAlias('tabb', 'tabnew|b')

if has("nvim")
	call CmdAlias('ster', 'new|ter')
	call CmdAlias('vter', 'vnew|ter')
	" no alias for :ter - already expected behaviour
else
	call CmdAlias('ster', 'ter')
	call CmdAlias('vter', 'vert ter')
	call CmdAlias('ter', 'ter ++curwin')
endif
