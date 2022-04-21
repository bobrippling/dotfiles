if has("win32") || has("win32unix")
	" fix bug from:
	" https://github.com/git-for-windows/git/issues/3662
	" https://github.com/vim/vim/issues/6040
	tnoremap <S-space> <space>
endif
