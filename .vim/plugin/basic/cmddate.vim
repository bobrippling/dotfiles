let s:ignore_next = 0

function! s:get_date(is_cmdline)
	let s:ignore_next = 1
	return strftime("%Y-%m-%d") . (a:is_cmdline ? "-" : "")
endfunction

function! s:check_date_typed()
	let now_re = strftime("\\v%Y.?%m.?%d")
	let cmd = getcmdline()

	let [matched, start, end] = matchstrpos(cmd, now_re)
	if start ==# -1
		return
	endif

	if s:ignore_next
		let s:ignore_next = 0
		return
	endif

	let where = getcmdpos() - 1
	if end ==# where
		throw "You can use <C-R><C-D> for the date"
	endif
endfunction

cnoremap <expr> <C-R><C-D> <SID>get_date(1)
inoremap <expr> <C-R><C-D> <SID>get_date(0)

augroup CmdDate
	autocmd!
	autocmd CmdlineChanged * call s:check_date_typed()
augroup END
