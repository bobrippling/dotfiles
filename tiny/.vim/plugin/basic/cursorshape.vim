function s:setup()
	if has("nvim")
		highlight TermCursorNC ctermfg=15 ctermbg=14 cterm=none
	else
		" change cursor shape on insert
		let &t_SI = "\e[6 q"
		let &t_SR = "\e[4 q"
		let &t_EI = "\e[2 q"

		" don't let vim change cursor color:
		set t_SC=
		set t_EC=
	endif
endfunction

function VimrcDisableCursorShaping()
	if has("nvim")
		set guicursor=
	else
		" not sure if this works
		let &t_SI = ""
		let &t_SR = ""
		let &t_EI = ""
	endif
endfunction

call s:setup()
