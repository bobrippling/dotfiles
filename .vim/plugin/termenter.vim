let s:tty_open_event = has("nvim") ? "TermOpen" : "TerminalWinOpen"

augroup TermEnter
	autocmd!

	execute "autocmd" s:tty_open_event "* setlocal nospell"
augroup END

if !has("nvim")
	function! s:terminal_normal() abort
		if &buftype ==# "terminal"
			call feedkeys("\<C-\>\<C-N>", "n")
		endif
	endfunction

	augroup TermEnter
		" vim - match nvim's start-termainal-in-normal-mode behaviour
		execute "autocmd" s:tty_open_event '* call feedkeys("\<C-W>N", "n")'

		" vim - leave terminal in insert mode for scrolling/output,
		" but then revert to normal-mode when focused
		autocmd WinEnter,BufWinEnter * call s:terminal_normal()
	augroup END
endif

unlet s:tty_open_event
