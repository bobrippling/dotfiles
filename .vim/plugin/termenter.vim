function! s:get_event_name()
	for name in ["TermOpen", "TerminalWinOpen", "TerminalOpen"]
		if exists("##" . name)
			return name
		endif
	endfor
	return ""
endfunction

let s:tty_open_event = s:get_event_name()
if !empty(s:tty_open_event)
	augroup TermEnter
		autocmd!

		execute "autocmd" s:tty_open_event "* setlocal nospell"
	augroup END
endif

if !has("nvim")
	function! s:terminal_normal() abort
		if &buftype ==# "terminal"
			call feedkeys("\<C-\>\<C-N>", "n")
		endif
	endfunction

	augroup TermEnter
		if !empty(s:tty_open_event)
			" vim - match nvim's start-termainal-in-normal-mode behaviour
			execute "autocmd" s:tty_open_event '* call feedkeys("\<C-W>N", "n")'
		endif

		" vim - leave terminal in insert mode for scrolling/output,
		" but then revert to normal-mode when focused
		autocmd WinEnter,BufWinEnter * call s:terminal_normal()
	augroup END
endif

unlet s:tty_open_event
