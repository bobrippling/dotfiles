if has("nvim")
	augroup YankHighlight
		autocmd!
		" see :h lua-highlight
		autocmd TextYankPost * silent! lua vim.highlight.on_yank()
	augroup END
endif
