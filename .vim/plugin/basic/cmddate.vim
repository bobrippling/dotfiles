let s:ignore_next = 0

function! s:get_date()
	let s:ignore_next = 1
	return strftime("%Y-%m-%d")
endfunction

function! GetDateOrgzly()
	return strftime("%Y-%m-%d %a %H:%M")
endfunction

function! s:get_time()
	return strftime("%H:%M")
endfunction

cnoremap <expr> <C-R><C-D> <SID>get_date() . '-'
inoremap <expr> <C-R><C-D> <SID>get_date()

cnoremap <expr> <C-R><C-Z> GetDateOrgzly() . '-'
inoremap <expr> <C-R><C-Z> GetDateOrgzly()

cnoremap <expr> <C-R><C-T> <SID>get_time() . '-'
inoremap <expr> <C-R><C-T> <SID>get_time()

if 0
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

	augroup CmdDate
		autocmd!
		autocmd CmdlineChanged * call s:check_date_typed()
	augroup END
endif
