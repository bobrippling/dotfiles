if exists("#TermOpen")
	augroup TermEnter
		autocmd!

		autocmd TermOpen * setlocal nospell
	augroup END
endif
