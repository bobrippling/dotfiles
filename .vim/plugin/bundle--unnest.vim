" see ~/.vim/bundle/unnest.nvim/plugin/unnest.lua
"let g:unnest_cmd = "new"

if !empty(filter(argv(), { _, f -> match(@%, '\v/jj-.*(left|resolve)') >= 0 }))
	let g:loaded_unnest = 1
	if !empty($NVIM)
		echom "`jj diffedit/resolve` detected -> unnest disabled (for jj.vim)"
	endif
endif

