if !has('nvim')
	finish
endif

augroup NvimHighlighting
	au!
	autocmd TextYankPost * silent! lua vim.hl.on_yank {higroup='IncSearch', timeout=300, on_visual=true, on_macro=true}
augroup END
